# -*- mode: ruby -*-

require 'ixtlan/gettext/crawler'

namespace :ixtlan do

  namespace :gettext do
    desc 'crawls the local filesystem for _(...) method calls and dumps them to the console'
    task :keys => :environment do
      print "\t"
      puts Ixtlan::Gettext::Crawler.crawl.join( "\n\t" )
    end

    task :update => :environment do
      puts 'crawling files . . .'
      data = {:translation_keys => Ixtlan::Gettext::Crawler.crawl }
      puts "sending #{data[:translation_keys].size} keys to gettext server . . ."
      keys = Rails.application.config.rest.update(Ixtlan::Gettext::TranslationKey, data)
      puts "updating local database with #{keys.size} stored keys . . ."
      Ixtlan::Gettext::TranslationKey.update_all(keys)
    end

    task :commit => :environment do
      keys = Rails.application.config.restserver.update(:translation_keys, :commit)
      Ixtlan::Gettext::TranslationKey.update_all(keys)
    end

    task :rollback => :environment do
      keys = Rails.application.config.restserver.update(:translation_keys, :rollback)
      Ixtlan::Gettext::TranslationKey.update_all(keys)
    end
  end

end
# vim: syntax=Ruby
