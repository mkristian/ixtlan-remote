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
    module ModelHelpers

      def to_model_underscore( data )
        m = to_model( data )
        m.to_s.underscore if m
      end

      def to_model_singular_underscore( data )
        to_model_underscore( data ).sub( /s$/, '' )
      end

      def to_model( data )
        case data
        when Hash
          if data.size == 1
            case data.values.first
            when Array
              data.keys.first
            when Hash
              data.keys.first
            end
          end
        when Array
          if data.empty?
            #TODO
          else
            to_model_class(data[0].class)
          end
        when String
          data
        when Symbol
          data
        when Class
          to_model_class(data)
        else
          to_model_class(data.class)
        end
      end

      def to_model_class(obj)
        if obj.respond_to?(:model_name) 
          obj.model_name.constantize
        elsif obj.is_a? Class
          obj
        else
          obj.class
        end
      end
    end
  end
end
