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
module Ixtlan
  module Remote
    module ConstantTimeCompare

      # from https://github.com/django/django/blob/master/django/utils/crypto.py#L82
      # time to compare is independent of the number of matching characters
      def constant_time_compare(val1, val2)
        if val1.size != val2.size
          return false
        end
        result = 0
        val1.unpack('C*').zip(val2.unpack('C*')).each do |a|
          result |= a[0][0] ^ a[1][0]
        end
        result == 0
      end
    end
  end
end
