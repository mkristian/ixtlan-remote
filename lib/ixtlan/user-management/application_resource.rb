module Ixtlan
  module UserManagement
    class Application
      include DataMapper::Resource

      def self.storage_name(arg)
        'ixtlan_applications'
      end

      property :id, Serial, :auto_validation => false

      property :name, String, :required => true, :unique => true, :length => 32
      property :url, String, :required => true, :format => /^https?\:\/\/[a-z0-9\-\.]+(\.[a-z0-9]+)*(\:[0-9]+)?(\/\S*)?$/, :length => 64, :lazy => true
      property :updated_at, DateTime, :required => true, :lazy => true

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
  end
end
