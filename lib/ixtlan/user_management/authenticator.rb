require 'ixtlan/user_management/authentication_model'
module Ixtlan
  module UserManagement
    class Authenticator

      def initialize(restserver)
        @restserver = restserver
      end
      def user_new(params)
        User.new(params)
      end
      def login( username_or_email, password )
        user = nil
        @restserver.create( Authentication.new(:login => username_or_email, :password => password) ) do |json|
p json
          user = user_new( JSON.load( json ) )
          nil
        end
        user
      end
      
      def reset_password(username_or_email)
        @restserver.create( Authentication, :reset_password, :login => username_or_email ) do
          # ignore result
          nil
        end

      end
    end
  end
end
