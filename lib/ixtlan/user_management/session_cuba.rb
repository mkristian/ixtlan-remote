# -*- Coding: utf-8 -*-
require 'ixtlan/user_management/session_plugin'

module Ixtlan
  module UserManagement
  
    class SessionCuba < CubaAPI

      plugin SessionPlugin

      define do
        on post, :reset_password do
          if msg = self.class.authenticator.reset_password( login_and_password[ 0 ] )
            log msg
            head 200
          else
            log "user/email not found"
            head 404
          end
        end

        on post do
          user = self.class.authenticator.login( *login_and_password )
          if user      
            current_user( user )
            write self.class.sessions.create( user )
          else
            log "access denied"
            head 403
          end
        end
        
        on get, :ping do
          head 200
        end
        
        on delete do
          log "logout"
          reset_current_user
        end
      end
    end
  end
end
