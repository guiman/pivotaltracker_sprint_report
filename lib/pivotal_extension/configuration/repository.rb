module Pivotal
  module Configuration
    class Repository
      @@map ||= {}

      def self.store(key, value)
        @@map[key] = value
      end

      def self.get(key)
        @@map.fetch(key)
      end

      def self.clear!
        @@map = {}
      end
    end
  end
end
