# -*- Coding: utf-8 -*-
require 'ixtlan/user_management/authenticator'

module Ixtlan
  module UserManagement
    module SessionPlugin

      module ClassMethods
        def authenticator
          self[ :authenticator ] ||= Authenticator.new( self[ :rest ] )
        end
      end

      def log( msg )
        if self.respond_to? :audit
          audit( msg, { :username => login } )
        else
          warn( "[#{login}] #{msg}" )
        end
      end
  
      def login_and_password
        auth = req[:authentication] || req
        [ auth[:login] || auth[:email], auth[:password] ]
      end
      
      def login
        login_and_password[ 0 ]
      end
    end
  end
end
