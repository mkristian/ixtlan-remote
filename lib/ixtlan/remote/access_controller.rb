require 'ixtlan/remote/constant_time_compare'
module Ixtlan
  module Remote
    module AccessController
      include Ixtlan::Remote::ConstantTimeCompare

      # this implementation uses rails request instance
      def x_service_token
        request.headers['X-SERVICE-TOKEN']
      end
      private :x_service_token

      def remote_permission
        @_remote_permission ||= 
          begin
            # constant time for finding the right permission
            perm = nil
            token = x_service_token
            raise "ip #{request.remote_ip} sent no token" unless token
            Permission.all.each do |rp|
              perm = rp if constant_time_compare(rp.token, token)
            end
            raise "ip #{request.remote_ip} wrong authentication" unless perm 
            # if the perm.ip == nil then do not check IP 
            # server clusters have many IPs then use perm.ip = nil
            raise "ip #{request.remote_ip} not allowed" if (!perm.ip.blank? && request.remote_ip != perm.ip)
            perm
          end
      end
    end
  end
end
