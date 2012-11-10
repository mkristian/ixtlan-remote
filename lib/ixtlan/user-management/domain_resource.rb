module Ixtlan
  module UserManagement
    class Domain

      include DataMapper::Resource

      def self.storage_name(arg)
        'ixtlan_domains'
      end

      property :id, Serial  
      property :name, String, :format => /^[a-z]+$/,:required => true, :length => 32

      timestamps :updated_at

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end
    end
  end
end
