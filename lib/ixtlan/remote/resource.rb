require 'ixtlan/remote/model_helpers'
module Ixtlan
  module Remote
    class Resource

      include ModelHelpers

      def initialize(resource, model_map = {})
        @base = resource
        @map = model_map
      end

      def send_it(&block)
        raise "no method given - call any CRUD method first" unless @method
        headers = {:content_type => :json, :accept => :json}
        headers[:params] = @params if @params
        result =
          if @payload
            @resource.send( @method, @payload.to_json, headers, &block )
          else
            @resource.send( @method, headers, &block )
          end
        unless result.blank?
          result = JSON.load( result )
          if @model
            root = @map[ @model ].singular || @model_key
            if result.is_a? Array
              if result.empty?
                []
              else
                root = 
                  if result[ 1 ].is_a?( Hash ) && result[ 1 ].size == 1
                    root
                  end
                result.collect do |r|
                  new_instance( @model, r[root] || r )
                end
              end
            else
              attr = if result.is_a?( Hash ) && result.size == 1
                       result[root]
                     else
                       result
                     end
              new_instance(@model, attr)
            end
          else
            result
          end
        end
      end

      def query_params(params)
        @params = params
        self
      end

      # retrieve(Locale) => GET /locales
      # retrieve(Locale, 1) => GET /locales/1
      # retrieve(:locales) => GET /locales
      # retrieve(:locales, 1) => GET /locales/1
      def retrieve(*args)
        @method = :get
        @params = nil
        @resource = @base[path(*args)]
        @payload = nil
        self
      end

      # create(locale) => POST /locales
      # create(:locale => {:code => 'en'}) => POST /locales
      def create(*obj_or_hash)
        @method = :post
        @payload = nil#obj_or_hash.is_a?(Class)? nil : obj_or_hash
        @params = nil
        @resource = @base[path(*obj_or_hash)]
        self
      end

      def update(*obj_or_hash)
        @method = :put
        @payload = nil#obj_or_hash.is_a?(Class)? nil : obj_or_hash
        @params = nil
        @resource = @base[path(*obj_or_hash)]
        self
      end

      def delete(*obj_or_hash)
        @method = :delete
        @payload = nil #obj_or_hash.is_a?(Class)? nil : obj_or_hash
        @params = nil
        @resource = @base[path(*obj_or_hash)]
        self
      end

      def model
        @model
      end

      private

      def new_instance( clazz, attributes )
        @map[ clazz ].new( attributes )
      end

      def path(*parts)
        parts.collect { |p| path_part( p ) }.delete_if { |p| p.nil? } * '/'
      end

      def model_set(model)
        m = model.singularize.camelize.constantize rescue nil
        if m
          @model = m 
          @model_key = model.singularize.underscore
        end
      end

      def path_part(data)
        model = to_model_underscore(data)
        case data
        when Hash
          @payload = data
          if model_set(model)
            model = model.pluralize
          else
            model = nil
          end
        when Array
          @payload = data
          if model_set model
            model = model.pluralize
          end
        when String
          model_set model
        when Fixnum
          model = data.to_s
        when Symbol
          model_set model
        when Class
          model_set model
          model = @map.member?( data ) ? @map[ data ].path : model.pluralize
        else
          @payload = data
          model_set model
          model = model.pluralize
        end
        model.underscore if model
      end

    end
  end
end
