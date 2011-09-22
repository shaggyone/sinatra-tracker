require 'rubygems'

#gem 'sinatra'
#gem 'ruby-tracker'

require 'sinatra/base'
#require 'bencoded_record'
require 'pp'


class MemoryTorrentDirectory
  include ::Torrent::Directory
  @@torrents = {}


  def self.load_folder(path)
    Dir.glob(path).each do |filename|
      pp filename
      self.load_file filename
    end
  end

  def self.load_file(filename)
    data = File.read(filename)
    data = data.force_encoding("ISO-8859-1") if data.respond_to?(:force_encoding)
    torrent = BEncode::BencodedRecord.load(data)
    @@torrents[torrent.info.hexdigest] = torrent
    pp torrent.info.hexdigest
    torrent
  end

  def self.allowed_torrent?(params)
    @@torrents.key?(params[:info_hash])
  end

  def self.get_torrent(info_hash)
    @@torrents[info_hash]
  end
end

class Tracker < Torrent::Tracker
  def initialize(params)
    self.torrent_directory = MemoryTorrentDirectory
    self.peer_info_class = Torrent::MemoryPeerInfo
    torrent_directory.load_folder params[:torrents_folder]
  end
end

class SinatraTracker < Sinatra::Base
  set :sessions, true

  def self.init_torrent_tracker
    torrents_folder = File.join($config['torrents_dir'], '*.torrent')
    Tracker.new :torrents_folder => torrents_folder
  end

  configure do
    $config = YAML.load(File.read(File.join(File.dirname(__FILE__), 'config', 'config.yml')))[Sinatra::Application.environment.to_s]
    $tracker = init_torrent_tracker
  end

  get '/ns-announce' do
    puts request.query_string

    content_type 'text/plain'
    params['ip'] ||= request.ip
    $tracker ||= init_torrent_tracker
    _params = {}
    params.each do |k, v|
      _params[k.to_sym] = v
    end

    pp "params[] = ", _params

    a = $tracker.announce(_params)
    a['interval'] = 60
    a['min_interval'] = 60
    pp a
    pp a.bencode
    a.bencode
  end

  get '/sscrape' do
    puts "**Scrape**"
    puts request.query_string
    $tracker ||= init_torrent_tracker
    info_hashs = request.query_string.split('&').map {|x| x.split('=')}.find_all {|x| x[0]=='info_hash'}.map {|x| URI.unescape(x[1])}
    a = $tracker.scrape info_hashs
    pp a
    pp a.bencode
    content_type 'text/plain'
    a.bencode
  end

end

#SinatraTracker.run! :host => '192.168.0.101', :port => 2222
