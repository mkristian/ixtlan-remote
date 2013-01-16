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
module Ixtlan
  module UserManagement
    module DummyAuthentication

      def self.need_dummy?( rest, server )
        url = rest.to_server( server ).url
        (url =~ /localhost/ || url =~ /127.0.0.1/ || url =~ /::1/) && !(ENV['SSO'] == 'true' || ENV['SSO'] == '')
      end

      def login(login, password)
        if ! login.blank? && password.blank?
          result = setup_user
          result.login = login.sub( /\[.*/, '' )
          result.name = result.login.capitalize
          result.groups = [ setup_group( login ) ]
          result.applications = [] if result.respond_to? :applications
          result
        end
      end

      protected

      def setup_user
        if u = user_model.get!(1)
          result = u
        else
          result.id = 1
          result.updated_at = DateTime.now
        end
      end

      def user_model
        User
      end
        
      def setup_group( login )
        group_for( Group, login )
      end

      def group_for( model, login )
        model.new('name' => login.sub( /\[.*/, '' ) )
      end

      def split( login )
        login.sub( /.*\[/ , '' ).sub( /\].*/, '' ).split( /,/ )
      end

    end
  end
end