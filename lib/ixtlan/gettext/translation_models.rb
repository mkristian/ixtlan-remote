module Ixtlan
  module Gettext
    class TranslationKey
      include DataMapper::Resource

      def self.storage_name(arg)
        'gettext_keys'
      end

      property :id, Serial
      property :name, String, :unique=>true, :required => true
      
      property :updated_at, DateTime, :required => true, :lazy => true

      def self.update_all(keys)
        ids = keys.collect do |k|
          k.save
          k.id
        end
        all(:id.not => ids).destroy!
      end

      def self.translation(key, locale)
        TranslationText.first(TranslationKey.name => key, Locale.code => locale)
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
     class Locale
      include DataMapper::Resource

      def self.storage_name(arg)
        'gettext_locales'
      end

      property :id, Serial
      property :code, String, :unique=>true, :required => true, :format => /^[a-z][a-z](_[A-Z][A-Z])?$/, :length => 5
      
      property :updated_at, DateTime, :required => true, :lazy => true

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
    class TranslationText
      include DataMapper::Resource

      def self.storage_name(arg)
        'gettext_texts'
      end

      belongs_to :locale, Locale.to_s,:key => true
      belongs_to :translation_key, TranslationKey.to_s, :key => true
      
      property :text, String, :required => true

      property :updated_at, DateTime, :required => true, :lazy => true

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
  end
end
