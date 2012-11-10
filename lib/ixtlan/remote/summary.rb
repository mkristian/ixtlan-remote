class Ixtlan::Remote::Sync

  class Summary

    def initialize(clazz)
      @count = 0
      @failures = []
      @clazz = clazz
    end

    def inc_count
      @count += 1
    end

    def inc_failures(errors)
      @failures << errors.inspect
    end

    def to_log
      "update #{@clazz} - total: #{@count + @failures.size}  success: #{@count}  failures: #{@failures.join("\n\t\t")}"
    end
  end
end
