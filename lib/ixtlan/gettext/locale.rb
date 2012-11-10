module Ixtlan
  module Gettext
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
  end
end
