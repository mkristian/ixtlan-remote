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
require 'virtus'
module Ixtlan
  module UserManagement
    class Session
      include Virtus

      attribute :idle_session_timeout, Integer
      attribute :user, User
      attribute :permissions, Array[Object]

      def to_s
        "Session( #{user.name}<#{user.login}> groups[ #{user.groups.collect { |g| g.name }.join ',' } ] #{idle_session_timeout} )"
      end
    end
  end
end
