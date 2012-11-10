require 'ixtlan/remote/rest'
module Ixtlan
  module Remote

    class Railtie < Rails::Railtie

      config.restserver = Ixtlan::Remote::Rest.new

      rake_tasks do
        load 'ixtlan/gettext/translation.rake'
      end
    end
  end
end
