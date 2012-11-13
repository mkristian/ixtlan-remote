# -*- mode: ruby -*-
namespace :ixtlan do

  namespace :gettext do
    desc 'crawls the local filesystem for _(...) method calls and sends the collected translation keys to the remote service'
    task :update => :environment do
      data = {:translation_keys => ENV['KEYS'].split(/,/)}
      keys = Rails.application.config.restserver.update(data)
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
