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
require 'ixtlan/remote/constant_time_compare'
module Ixtlan
  module Remote
    module AccessController

      private

      include Ixtlan::Remote::ConstantTimeCompare

      # this implementation uses rails request instance
      def x_service_token
        request.headers['X-SERVICE-TOKEN']
      end

      protected

      def permission_model
        Permission
      end

      public

      def remote_permission
        @_remote_permission ||= 
          begin
            # constant time for finding the right permission
            perm = nil
            token = x_service_token
            raise "ip #{request.remote_ip} sent no token" unless token
            permission_model.all.each do |rp|
              perm = rp if rp.authentication_token && constant_time_compare(rp.authentication_token, token)
            end
            raise "ip #{request.remote_ip} wrong authentication" unless perm 
            # if the perm.ip == nil then do not check IP 
            # server clusters have many IPs then use perm.ip = nil
            raise "ip #{request.remote_ip} not allowed" if (!perm.allowed_ip.blank? && request.remote_ip != perm.allowed_ip)
            perm
          end
      end
    end
  end
end
