module Ixtlan
  module Remote
    class Permission

      include DataMapper::Resource
 
      # key for selectng the IdentityMap should remain this class 
      # there is no single table inheritance with Discriminator in place
      def self.base_model
        self
      end

      property :id, Serial
      
      property :ip, String
      property :token, String
    end
  end
end
