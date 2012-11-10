module Ixtlan
  module Remote
    module ConstantTimeCompare

      # from https://github.com/django/django/blob/master/django/utils/crypto.py#L82
      # time to compare is independent of the number of matching characters
      def constant_time_compare(val1, val2)
        if val1.size != val2.size
          return false
        end
        result = 0
        val1.unpack('*C').zip(val2.unpack('*C')).each do |a|
          result |= a[0][0] ^ a[1][0]
        end
        result == 0
      end
    end
  end
end
