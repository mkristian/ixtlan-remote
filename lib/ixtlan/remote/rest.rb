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
        to_server( model ).new_rest_resource
      end

      def create(model, *args, &block)
        if args.size == 0 && model.respond_to?(:attributes)
          clazz = model.class
          new_resource(clazz).create(clazz, model.attributes).send_it(&block)
        else
          new_resource(model).create(model, *args).send_it(&block)
        end
      end

      def retrieve( model, *args )
        resource = new_resource( model )
        if args.last.is_a? Hash
          params = args.delete_at( args.size - 1 )
          resource.retrieve( model, *args ).query_params( params )
        else
          resource.retrieve( model, *args )
        end
        resource.send_it
      end

      def update(model, *args)
        if args.size == 0 && model.respond_to?(:attributes)
          clazz = model.class
          s = to_server( clazz )
          s.new_rest_resource.update(clazz, 
                                     s.keys(model), 
                                     model.attributes).send_it
        else
          new_resource(model).update(model, *args).send_it
        end
      end

      def delete(model, *args)
        if args.size == 0 && model.respond_to?(:attributes)
          clazz = model.class
          s = to_server( clazz )
          s.new_rest_resource.delete(clazz, 
                                     s.keys( model ), 
                                     model.attributes).send_it
        else
          new_resource(model).delete(model, *args).send_it
        end
      end
    end
  end
end
