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
      if File.exists?(file)
        symbolize_keys(YAML::load(ERB.new(IO.read(file)).result))
        warn "[Passwords] Loaded #{file} file"
      else
        file = File.expand_path( file ).sub( /#{File.expand_path '.' }\/?/, '' )
        warn "[Passwords] No #{file} file to load"
      end
    end

    def self.config( file = 'password.yml' )
      @config ||= load( file ) || HashWithDefault.new
    end

    def self.[]( key )
      @config[ key ]
    end

    def self.get( key )
      @config.get( key )
    end
  end
end
