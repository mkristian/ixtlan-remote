#
# ixtlan-remote - helper sync data between miniapps or communicate wth realtime
# rest-services
# Copyright (C) 2012 Christian Meier
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
module Ixtlan
  module UserManagement
    class User

      include DataMapper::Resource

      def self.storage_name(arg)
        'ixtlan_users'
      end

      # key for selectng the IdentityMap should remain this class if
      # there is no single table inheritance with Discriminator in place
      # i.e. the subclass used as key for the IdentityMap
      def self.base_model
        self
      end

      property :id, Serial, :auto_validation => false
      
      property :login, String, :required => true, :unique => true, :length => 32
      property :name, String, :required => true, :length => 128
      property :updated_at, DateTime, :required => true

      attr_accessor :groups, :applications

      # do not record timestamps since they are set from outside
      def set_timestamps_on_save
      end

      def initialize(params = {})
        super
      end
    end
  end
end