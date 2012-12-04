require 'virtus'
module Ixtlan
  module UserManagement
    class Authentication
      include Virtus

      attribute :login, String
      attribute :password, String
    end
  end
end
