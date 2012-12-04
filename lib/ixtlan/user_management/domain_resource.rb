module Ixtlan
  module UserManagement
    class Domain

      include DataMapper::Resource

      def self.storage_name(arg)
        'ixtlan_domains'
      end

      # key for selectng the IdentityMap should remain this class if
      # there is no single table inheritance with Discriminator in place
      # i.e. the subclass used as key for the IdentityMap
      def self.base_model
        self
      end

      property :id, Serial  
      property :name, String, :unique=>true, :format => /^[a-z]+$/,:required => true, :length => 32

      timestamps :updated_at

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
  end
end
