require 'fast_gettext'
module Ixtlan
  module Gettext
    class Manager
      
      DEFAULT = 'default'

      def initialize
        FastGettext.default_text_domain = DEFAULT
        @default_repo = build( DEFAULT )
      end

      def use( locale, name = DEFAULT )
        unless FastGettext.translation_repositories.key?( name )
          repos = [ build( "#{name}-overlay" ), @default_repo ]
          FastGettext.add_text_domain name, :type=>:chain, :chain=> repos
        end
        FastGettext.set_locale(locale)
        FastGettext.text_domain = name
      end

      private

      def build( name )
        FastGettext::TranslationRepository.build( name, :type => :ixtlan )
      end
    end
  end
end
