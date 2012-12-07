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
    class Summary

      attr_reader :failures, :count

      def initialize(clazz)
        @count = 0
        @failures = []
        @clazz = clazz
      end
      
      def inc_count
        @count += 1
      end
      
      def inc_failures(errors)
        @failures << errors.inspect
      end
      
      def to_log
        "update #{@clazz} - total: #{@count + @failures.size}  success: #{@count}  failures: #{@failures.size == 0 ? 0 : @failures.join("\n\t\t")}"
      end
    end
  end
end