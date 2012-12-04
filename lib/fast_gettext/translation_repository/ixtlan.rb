require 'ixtlan/user_management/domain_resource'
require 'ixtlan/gettext/models'

module FastGettext
  module TranslationRepository
    class Ixtlan

      def initialize(name,options={})
        @name = name
      end

      @@seperator = '||||' # string that seperates multiple plurals
      def self.seperator=(sep);@@seperator = sep;end
      def self.seperator;@@seperator;end

      def available_locales
        []
      end

      def pluralisation_rule
        nil
      end

      def [](key)
        ::Ixtlan::Gettext::Translation.first(::Ixtlan::Gettext::Translation.translation_key.name => key, 
                                             ::Ixtlan::Gettext::Translation.locale.code => FastGettext.locale, 
                                             :domain => @domain)
      end

      def plural(*args)
        if translation = self[ args*self.class.seperator ]
          translation.to_s.split(self.class.seperator)
        else
          []
        end
      end

      private
      
      def domain
        @domain ||= ::Ixtlan::UserManagement::Domain.first( :name => @name )
        raise "domain not found: #{@name}" unless @domain
        @domain
      end
    end
  end
end
