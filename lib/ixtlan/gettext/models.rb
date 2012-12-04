require 'ixtlan/gettext/locale_resource'
require 'ixtlan/user_management/domain_resource'

module Ixtlan
  module Gettext
    class TranslationKey
      include DataMapper::Resource

      def self.storage_name(arg)
        'gettext_keys'
      end

      property :id, Serial
      property :name, Text, :unique=>true, :required => true, :length => 4096
      
      property :updated_at, DateTime, :required => true, :lazy => true

      def self.update_all(keys)
        ids = keys.collect do |k|
          k.save
          k.id
        end
        all(:id.not => ids).destroy!
      end

      def self.translation(key, locale)
        Translation.first(TranslationKey.name => key, Locale.code => locale)
      end

      def self.available_locales
        Translation.all(:fields => [:locale_id], :unique => true).collect do |t|
          t.locale
        end
      end
      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
    class Translation
      include DataMapper::Resource

      def self.storage_name(arg)
        'gettext_texts'
      end

      belongs_to :translation_key, TranslationKey.to_s, :key => true
      belongs_to :locale, Locale.to_s,:key => true
      belongs_to :domain, Ixtlan::UserManagement::Domain.to_s,:key => true
      
      property :text, Text, :required => true, :length => 4096

      property :updated_at, DateTime, :required => true, :lazy => true

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
  end
end
