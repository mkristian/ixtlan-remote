module Ixtlan
  module UserManagement
    class Group
      include Virtus

      attribute :name, String
      attribute :associations, Array[Object]
    end
  end
end
