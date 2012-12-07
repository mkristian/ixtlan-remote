#
# ixtlan-remote - helper sync data between miniapps or communicate wth realtime
# rest-services
# Copyright (C) 2012 Christian Meier
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
require 'ixtlan/user_management/authentication_model'
module Ixtlan
  module UserManagement
    class Authenticator

      def initialize(restserver)
        @restserver = restserver
      end

      def user_new(params)
        User.new(params)
      end

      def login( username_or_email, password )
        user = nil
        @restserver.create( Authentication.new(:login => username_or_email, :password => password) ) do |json|
          user = user_new( JSON.load( json ) ) unless json.strip.empty?
          nil
        end
        user
      end
      
      def reset_password(username_or_email)
        @restserver.create( Authentication, :reset_password, :login => username_or_email ) do
          # ignore result
          nil
        end
      end
    end
  end
end