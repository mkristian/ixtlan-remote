module Ixtlan
  module UserManagement
    class User

      include DataMapper::Resource

      def self.storage_name(arg)
        'ixtlan_users'
      end

      property :id, Serial, :auto_validation => false
      
      property :login, String, :required => true, :unique => true, :length => 32
      property :name, String, :required => true, :length => 128
      property :updated_at, DateTime, :required => true

      attr_accessor :groups, :applications, :domain

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
  end
end
