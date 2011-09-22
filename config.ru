require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'bencode'
require 'bencoded-record'
require 'torrent/tracker'

root_dir = File.dirname(__FILE__)

set :environment, ENV['RACK_ENV'].to_sym
set :root,        root_dir
set :app_file,    File.join(root_dir, 'tracker.rb')
disable :run

require File.join(File.dirname(__FILE__), 'tracker')

#run Sinatra::Application
run SinatraTracker
