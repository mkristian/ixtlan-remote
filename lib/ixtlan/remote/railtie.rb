require 'ixtlan/remote/rest'
module Ixtlan
  module Remote
    class Railtie < Rails::Railtie

      config.rest = Ixtlan::Remote::Rest.new
      
    end
  end
end
