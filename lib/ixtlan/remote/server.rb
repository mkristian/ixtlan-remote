require 'rest-client'
require 'ixtlan/remote/resource'
module RestClient
  class Resource
    # allow payload on delete - breaks code using original method !!!!
    def delete(payload = nil, additional_headers={}, &block)
     # raise "#{additional_headers.inspect} #{payload.inspect}"
      headers = (options[:headers] || {}).merge(additional_headers)
      if payload
        Request.execute(options.merge(
                                      :method => :delete,
                                      :url => url,
                                      :payload => payload,
                                      :headers => headers), &(block || @block))
      else
        Request.execute(options.merge(
                                      :method => :delete,
                                      :url => url,
                                      :headers => headers), &(block || @block))
      end
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

      if defined? DataMapper
        NEW_METHOD = Proc.new do | model, attributes |
          cond = {}
          model.key.each { |k| cond[ k.name ] = attributes[ k.name.to_s ] }
          m = model.first_or_new( cond )
          m.attributes = attributes
          m
        end
        
        def new_method( clazz )
          if clazz.respond_to?( :key ) && clazz.key.kind_of?( DataMapper::PropertySet )
            Proc.new { |a| NEW_METHOD.call( clazz, a ) }
          else
            clazz.method( :new )
          end
        end
      else
        warn "need better implementation for ActiveRecord in #{__FILE__}"
        
        def new_method( clazz )
          clazz.method( :new )
        end
      end


      def add_model( clazz, path = nil )#, &block )
        @factory[ clazz ] = self
        m = map[ clazz ] = Meta.new( new_method( clazz ),
                                     (path || clazz.to_s.underscore.pluralize ) )
        #block.call m if block
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
