require 'rest-client'
require 'ixtlan/remote/resource'
module Ixtlan
  module Remote
    class Server

      attr_accessor :url

      def initialize( factory )
        @factory = factory
      end

      def options
        @options ||= {}
      end

      def map
        @map ||= {}
      end
      
      class Meta

        attr_reader :path

        def initialize( new_method, path = nil )
          @new = new_method
          @path = path.to_s if path
        end

        def singular
          @path.singularize if @path
        end

        def new( attributes )
          @new.call( attributes )
        end
      end

      if defined? DataMapper
        
        NEW_METHOD = Proc.new do | model, attributes |
          cond = {}
          model.key.each { |k| cond[ k.name ] = attributes[ k.name.to_s ] }
          m = model.first_or_new( cond )
          m.attributes = attributes
          m
        end
        
        def new_method( clazz )
          #if clazz.include? ::DataMapper::Resource
          if clazz.respond_to?( :key ) && clazz.key.kind_of?( DataMapper::PropertySet )
            Proc.new { |a| NEW_METHOD.call( clazz, a ) }
          else
            clazz.method( :new )
          end
        end
      else
        raise "need implementation"
      end


      def add_model( clazz, path = nil )#, &block )
        @factory[ clazz ] = self
        m = map[ clazz ] = Meta.new( new_method( clazz ),
                                     (path || clazz.to_s.underscore.pluralize ) )
        #block.call m if block
      end

      def keys( clazz )
        if clazz.respond_to?( :key )
          clazz.key
        else
          # TODO
          clazz.id
        end
      end

      def new_rest_resource
        Resource.new( RestClient::Resource.new( @url, options ), map )
      end
    end
  end
end
