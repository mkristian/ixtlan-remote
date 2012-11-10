require 'ixtlan/remote/summary'
require 'active_support/all'

class Ixtlan::Remote::Sync

  SECONDS_IN_DAY = 60 * 60 * 24
  NANOSECONDS_IN_DAY = SECONDS_IN_DAY * 1000 * 1000 * 1000
  def initialize(restserver)
    @restserver = restserver
  end

  def clazzes
    @clazzes ||= {}
  end
  private :clazzes

  def register(clazz, &block)
    clazzes[clazz] = block unless clazzes.key?(clazz)
  end

  # max method ORM dependent
  if defined? ActiveRecord
    def max(clazz)
      clazz.maximum(:updated_at)
    end
  else
    def max(clazz)
      clazz.max(:updated_at)
    end
  end
  private :max

  # UTC timestamp of last updated record
  def last_update(clazz)
    last_date = ( max(clazz) || DateTime.new( 0 ) ) + 1# + SECONDS_IN_DAY
    last_date.strftime('%Y-%m-%d %H:%M:%S.') + ("%06d" % (last_date.sec_fraction / NANOSECONDS_IN_DAY / 1000)) + "+0:00"
  end
  private :last_update

  def self.do_it(clazz = nil)
    if clazz
      new.do_it(clazz)
    else
      new.do_it
    end
  end

  # load the last changed records
  def do_it(set = clazzes.keys)
    @last_result = []
    set = [set] unless set.is_a? Array
    set.to_a.each do |clazz|
      summary = Summary.new(clazz)
      @last_result << summary
      @restserver.retrieve(clazz, 
                           :last_changes, 
                           :updated_at => last_update(clazz)).each do |item|
        if item.save
          summary.inc_count
        else
          summary.inc_failures(item.errors)
        end
      end
      b = clazzes[clazz]
      b.call summary if b
    end
    to_log
  end

  def to_log
    if @last_result
      @last_result.collect { |r| r.to_log }.join("\n\t")
    else
      "no results yet"
    end
  end
  alias :to_s :to_log
end
