require 'rest-client'
require 'ixtlan/remote/resource'
module RestClient
  class Resource
    # allow payload on delete - breaks code using original method !!!!
    def delete(payload = nil, additional_headers={}, &block)
      headers = (options[:headers] || {}).merge(additional_headers)
      opts = options.merge( :method => :delete,
                            :url => url,
                            :headers => headers )
      if payload
        opts[:payload] = payload
      end
      Request.execute( opts, &(block || @block))
    end
  end
end

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
      
      def models
        map.keys
      end

      class Meta

        attr_reader :path, :new_method

        def initialize( new_method, path = nil )
          @new_method = new_method
          @path = path.to_s if path
        end
      end

      NEW_METHOD = Proc.new do | model, attributes |
        cond = {}
        model.key.each { |k| cond[ k.name ] = attributes[ k.name.to_s ] }
        m = model.first_or_new( cond )
        m.attributes = attributes
        m
      end
      
      def new_method_dm( clazz )
        if clazz.respond_to?( :key ) && clazz.key.kind_of?( DataMapper::PropertySet )
          Proc.new { |a| NEW_METHOD.call( clazz, a ) }
        else
          clazz.method( :new )
        end
      end

      def new_method(clazz)
        if defined? DataMapper
          new_method_dm(clazz)
        else
          warn "TODO need better implementation for ActiveRecord in #{__FILE__} #{__LINE__}"
        
          clazz.method( :new )
        end
      end

      def add_model( clazz, path = nil )
        @factory[ clazz ] = self
        m = map[ clazz ] = Meta.new( new_method( clazz ),
                                     (path || clazz.to_s.underscore.pluralize ) )
      end

      def keys( clazz )
        # TODO
        if clazz.respond_to?( :key )
          clazz.key.first
        else
          clazz.id
        end
      end

      def new_rest_resource( clazz )
        client = RestClient::Resource.new( @url, options )
        meta = map[ clazz ]
        Resource.new( client[ meta.path ], clazz, meta.new_method )
      end
    end
  end
end
