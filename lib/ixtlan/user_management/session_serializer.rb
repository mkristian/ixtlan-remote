require 'ixtlan/babel/serializer'
module Ixtlan
  module UserManagement
    class SessionSerializer < Ixtlan::Babel::Serializer

      root 'session'

      add_context(:single,
                  :only => [:idle_session_timeout],
                  :include => { 
                    :user => {
                    },
                    :permissions => {
                      :include => [:actions, :associations]
                    }
                  }
                  )
      
    end
  end
end
