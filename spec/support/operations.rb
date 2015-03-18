module Test
  module Pivotal
    class Operations < ::Pivotal::Operations
      def initialize(configuration: raise)
        @configuration = configuration
      end

      protected

      def call_api(endpoint: nil, params: "")
        cassette_name = endpoint.nil? ?  "project" : "#{endpoint}-#{params}"
        VCR.use_cassette(cassette_name) { super }
      end
    end
  end
end
