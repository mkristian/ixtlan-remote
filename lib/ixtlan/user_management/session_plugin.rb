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
require 'ixtlan/user_management/authenticator'

module Ixtlan
  module UserManagement
    module SessionPlugin

      module ClassMethods
        def authenticator
          self[ :authenticator ] ||= Authenticator.new( self[ :rest ] )
        end
      end

      def log( msg )
        if self.respond_to? :audit
          audit( msg, { :username => login } )
        else
          warn( "[#{login}] #{msg}" )
        end
      end
  
      def login_and_password
        auth = req[:authentication] || req
        [ auth[:login] || auth[:email], auth[:password] ]
      end
      
      def login
        login_and_password[ 0 ]
      end
    end
  end
end