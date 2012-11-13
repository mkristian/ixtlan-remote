module Ixtlan
  module UserManagement
    class Application
      include Virtus

      attribute :name, String
      attribute :url, String
    end
  end
end
