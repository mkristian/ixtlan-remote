require 'ixtlan/remote/rest'
require 'ixtlan/gettext/manager'
module Ixtlan
  
  class RemoteGettextRailtie < Rails::Railtie

    config.rest = Ixtlan::Remote::Rest.new
    
    config.gettext = Ixtlan::Gettext::Manager.new
    
    rake_tasks do
      load 'ixtlan/gettext/translation.rake'
    end
  end
end
