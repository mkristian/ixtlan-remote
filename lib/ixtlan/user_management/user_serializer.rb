require 'ixtlan/babel/serializer'
module Ixtlan
  module UserManagement
    class UserSerializer < Ixtlan::Babel::Serializer

      add_context(:session,
                  :only => [:login, :name],
                  :include=> { 
                    :groups => {
                      :only => [:name]
                    }
                  })
    end
  end
end
