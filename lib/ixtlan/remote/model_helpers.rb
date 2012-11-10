module Ixtlan
  module Remote
    module ModelHelpers

      def to_model_underscore(data)
        m = to_model(data)
        m.to_s.underscore if m
      end

      def to_model_singular_underscore(data)
        to_model_underscore(data).singularize
      end

      def to_model(data)
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
