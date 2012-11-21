module Ixtlan
  module UserManagement
    class User

      include DataMapper::Resource

      def self.storage_name(arg)
        'ixtlan_users'
      end

      # key for selectng the IdentityMap should remain this class if
      # there is no single table inheritance with Discriminator in place
      # i.e. the subclass used as key for the IdentityMap
      def self.base_model
        self
      end

      property :id, Serial, :auto_validation => false
      
      property :login, String, :required => true, :unique => true, :length => 32
      property :name, String, :required => true, :length => 128
      property :updated_at, DateTime, :required => true

      attr_accessor :groups, :applications

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end

      def initialize(params = {})
        super
      end
    end
  end
end
