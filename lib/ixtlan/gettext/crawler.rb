module Ixtlan
  module Gettext
    class Crawler

      def self.crawl
        Crawler.new.crawl
      end

      def crawl
        keys.clear
        Dir[File.join('app', 'views', '**', '*rb')].each do |f|
          File.read(f).each_line do |line|
            extract_key(line) if line =~ /_[ (]/
          end
        end
        keys.sort!
        keys.uniq!
        keys
      end
      
      private

      def keys
        @keys ||= []
      end
      
      def extract_key(line)
        extract(line, "'")
        extract(line, '"')
      end
      
      def extract(line, sep)
        if line =~ /.*_[ (][#{sep}]/
          # non-greedy +? and *? vs. greedy + and *
          k = line.sub( /.*?_[ (][#{sep}]/, '').sub(/[#{sep}].*\n/, '')
          keys << k; puts k unless keys.member? k
          extract_key(line.sub(/[^_]*_[ (][#{sep}][^#{sep}]+[#{sep}]/, ''))
        end
      end
    end
  end
end
