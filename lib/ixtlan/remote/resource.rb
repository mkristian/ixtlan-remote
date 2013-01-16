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
require 'ixtlan/remote/model_helpers'
module Ixtlan
  module Remote
    class Resource

      include ModelHelpers

      def initialize(resource, model, new_method = nil)
        @base = resource
        @model = model
        @new_method = new_method || @model.method(:new)
      end

      def create_result_objects( result ) 
        # naiv singularize english plural
        root = @model.to_s.sub(/.*::/, '').underscore.sub( /s$/, '')
        if result.is_a? Array
          result.collect do |r|
            new_instance( r[root] || r )
          end
        else
          attr = if result.is_a?( Hash ) && result.size == 1
                   result[root]
                 end
          new_instance( attr || result )
        end
      end
      private :create_result_objects

      def send_it(&block)
        raise "no method given - call any CRUD method first" unless @method
        headers = {:content_type => :json, :accept => :json}
        headers[:params] = @params if @params
        result =
          if @method != :get
            @resource.send( @method, @payload ? @payload.to_json : '', headers, &block )
          else
            @resource.send( @method, headers, &block )
          end
        if result && result.size > 0
          create_result_objects( JSON.load( result ) )
        else
          nil
        end
      end

      def query_params(params)
        @params = params
        self
      end

      def last(args)
        if args.last.is_a?(Hash)
          args.reverse!
          l = args.shift
          args.reverse!
          l
        end
      end

      def retrieve(*args)
        @method = :get
        @params = nil
        @resource = @base[path(*args)]
        @payload = nil
        self
      end

      def create(*obj_or_hash)
        @method = :post
        @payload = last(obj_or_hash)
        @params = nil
        @resource = @base[path(*obj_or_hash)]
        self
      end

      def update(*obj_or_hash)
        @method = :put
        @payload = last(obj_or_hash)
        @params = nil
        @resource = @base[path(*obj_or_hash)]
        self
      end

      def delete(*obj_or_hash)
        @method = :delete
        @payload = last(obj_or_hash)
        @params = nil
        @resource = @base[path(*obj_or_hash)]
        self
      end

      def model
        @model
      end

      private

      def new_instance( attributes )
        @new_method.call( attributes )
      end

      def path(*parts)
        parts.flatten.collect do |part|
          case part
          when Class
            part.to_s.pluralize.underscore
          else
            if part.respond_to? :attributes
              part.class.to_s.pluralize.underscore
            else
              part.to_s
            end
          end
        end * '/'
      end

      def path_part(data)
        unless data.is_a?(Hash)
          data = [data] unless data.is_a?(Array)
          data.collect { |d| d.to_s }.join("/")
        end
      end
    end
  end
end
