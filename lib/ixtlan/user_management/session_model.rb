module Ixtlan
  module UserManagement
    class Session
      include Virtus

      attribute :idle_session_timeout, Integer
      attribute :user, User
      attribute :permissions, Array[Object]
    end
  end
end
