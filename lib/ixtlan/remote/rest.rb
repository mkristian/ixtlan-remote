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
require 'ixtlan/remote/server'
module Ixtlan
  module Remote
    class Rest

      private

      include ModelHelpers

      def model_to_servers
        @_models ||= {}
      end

      def servers
        @_servers ||= {}
      end

      public

      def server( server_name, &block )
        server = servers[ server_name.to_sym ] ||= Server.new( self )
        block.call server if block
        server
      end
      
      def []=( clazz, server )
        model_to_servers[ to_model_singular_underscore( clazz ) ] = server
      end

      def to_server( model )
        s = model_to_servers[ to_model_singular_underscore( model ) ]
        raise "model #{model} unknown as rest service" unless s
        s
      end
      
      def new_resource( model )
        begin 
          m = to_model_singular_underscore( model ).camelize.constantize 
          to_server( model ).new_rest_resource( m )
        rescue
          raise "unknown model #{model}"
        end
      end

      def create( model, *args, &block )
        if model.respond_to?( :attributes )
          args << model.attributes
          model = model.class
        end
        new_resource( model ).create( *args ).send_it( &block )
      end

      def retrieve( model, *args )
        resource = new_resource( model )
        if args.last.is_a? Hash
          params = args.delete_at( args.size - 1 )
          resource.retrieve( *args ).query_params( params )
        else
          resource.retrieve( *args )
        end
        resource.send_it
      end

      def update_or_delete( method, model, *args )
        if model.respond_to?( :attributes )
          if args.size == 0
            args += model.key
            args << model.attributes
          else
            args << model.attributes
          end
          model = model.class
        end
        new_resource( model ).send( method, *args ).send_it
      end
      private :update_or_delete

      def update( model, *args )
        update_or_delete( :update, model, *args )
      end

      def delete( model, *args )
        update_or_delete( :delete, model, *args )
      end
    end
  end
end