require 'ixtlan/remote/rest'
module Ixtlan
  
  class RemoteGettextRailtie < Rails::Railtie

    config.rest = Ixtlan::Remote::Rest.new

  end
end
