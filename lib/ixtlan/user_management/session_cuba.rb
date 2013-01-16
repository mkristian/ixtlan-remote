#
# ixtlan-remote - helper sync data between miniapps or communicate wth realtime
# rest-services
# Copyright (C) 2013 Christian Meier
#
# This file is part of ixtlan-remote.
#
# ixtlan-remote is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# ixtlan-remote is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with ixtlan-remote.  If not, see <http://www.gnu.org/licenses/>.
#
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
            # be compliant with rack-protection and rack-csrf
            csrf = session[ :csrf ] || session[ "csrf.token" ]
            res[ 'X-CSRF-TOKEN' ] = csrf if csrf
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