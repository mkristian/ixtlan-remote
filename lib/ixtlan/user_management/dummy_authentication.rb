module Ixtlan
  module UserManagement
    module DummyAuthentication

      def self.need_dummy?( rest, server )
        url = rest.to_server( server ).url
        (url =~ /localhost/ || url =~ /127.0.0.1/ || url =~ /::1/) && !(ENV['SSO'] == 'true' || ENV['SSO'] == '')
      end

      def login(login, password)
        if ! login.blank? && password.blank?
          result = setup_user
          result.login = login.sub( /\[.*/, '' )
          result.name = result.login.capitalize
          result.groups = [ setup_group( login ) ]
          result.applications = [] if result.respond_to? :applications
          result
        end
      end

      protected

      def setup_user
        if u = user_model.get!(1)
          result = u
        else
          result.id = 1
          result.updated_at = DateTime.now
        end
      end

      def user_model
        User
      end
        
      def setup_group( login )
        group_for( Group, login )
      end

      def group_for( model, login )
        model.new('name' => login.sub( /\[.*/, '' ) )
      end

      def split( login )
        login.sub( /.*\[/ , '' ).sub( /\].*/, '' ).split( /,/ )
      end

    end
  end
end
