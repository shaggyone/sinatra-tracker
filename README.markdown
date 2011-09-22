Introdution
===========

This project is an example of using ruby-tracker gem.

Visit [ruby-tracker gem](https://github.com/shaggyone/ruby-tracker) homepagefor more info.

The main idea was, that you do not need a complex torrent tracker, when you want to share some of your files.
So it's very simple. It neither has any administration page nor user interface. When you start the application
it looks into torrents folder, and starts waiting for seeds and peers.

Using
=====

Clone the repository

    git clone git://github.com/shaggyone/sinatra-tracker.git
    cd sinatra-tracker

Install required gems

    bundle install

Set up dir where tracker will search  for torrent files.

    vim config/config.yml

Put your .torrent files into the configured dir.

Run the tracker

   ruby config.ru

or

  bundle exec rackup

Notes
=====

Announce url for torrent files will look like

    http://<host>[:port]/ns-announce
