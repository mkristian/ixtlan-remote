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
require 'ixtlan/user_management/user_serializer'
require 'ixtlan/user_management/session_model'
require 'ixtlan/user_management/session_serializer'

module Ixtlan
  module UserManagement
    class SessionManager

      attr_accessor :idle_session_timeout, :block

      def initialize( &block )
        @block = block || lambda { [] }
      end
      
      def serializer( user )
        UserSerializer.new( user )
      end

      def to_session( user )
        serializer( user ).use( :session ).to_hash
      end

      if User.respond_to?( :properties )
        def from_session( data ) 
          if data
            data = data.dup
            groups = (data.delete( 'groups' ) || []).collect do |g|
              Group.new( g )
            end
            user = User.first( :login => data[ 'login' ] )
            user.groups = groups
            user
          end
        end
      else
        def from_session( data ) 
          if data
            User.new( data )
          end
        end
      end

      def create( user )
        Session.new( 'user' => user,
                     'permissions' => block.call( user.groups ),
                     'idle_session_timeout' => idle_session_timeout )
      end
    end
  end
end
