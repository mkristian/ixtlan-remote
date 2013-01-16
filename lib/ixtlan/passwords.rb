#
# ixtlan-remote - helper sync data between miniapps or communicate wth realtime
# rest-services
# Copyright (C) 2013 Christian Meier
#
# This file is part of ixtlan-remote.
#
# ixtlan-remote is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# ixtlan-remote is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with ixtlan-remote.  If not, see <http://www.gnu.org/licenses/>.
#
require 'yaml'
require 'erb'
module Ixtlan
  class HashWithDefault < ::Hash
    def get( key, default = HashWithDefault.new )
      self[ key ] || default
    end
  end

  class Passwords

    def self.symbolize_keys(h)
      result = HashWithDefault.new

      h.each do |k, v|
        v = ' ' if v.nil?
        if v.is_a?(Hash)
          result[k.to_sym] = symbolize_keys(v) unless v.size == 0
        else
          result[k.to_sym] = v unless k.to_sym == v.to_sym
        end
      end
      result
    end

    def self.load( file )
      rel_file = File.expand_path( file ).sub( /#{File.expand_path '.' }\/?/, '' )
      if File.exists?( file )
        warn "[Passwords] Loaded #{rel_file} file"
        symbolize_keys( YAML::load( ERB.new( IO.read( file ) ).result ) )
      else
        warn "[Passwords] No #{rel_file} file to load"
      end
    end

    def self.config( file = 'password.yml' )
      @config ||= load( file ) || HashWithDefault.new
    end

    def self.[]( key )
      @config[ key ]
    end

    def self.get( key, default = nil )
      if default
        @config.get( key, default )
      else
        @config.get( key )
      end
    end
  end
end