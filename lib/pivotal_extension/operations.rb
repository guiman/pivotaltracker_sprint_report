require 'pivotal_extension/uri_builder'
require 'open-uri'
require 'json'

module Pivotal
  class Operations

    AVAILABLE_ENDPOINTS=[:stories, :iterations]
    PRIMARY_ENDPOINT="/projects/:project_id"

    def initialize(configuration: raise)
      @configuration = configuration
    end

    def project
      call_api
    end

    def project_name
      project['name']
    end

    def method_missing(name, *args, &block)
      if AVAILABLE_ENDPOINTS.include?(name)
        call_api(endpoint: name.to_s, params: args.first)
      else
        super
      end
    end

    protected

    def call_api(primary_endpoint: PRIMARY_ENDPOINT, endpoint: nil, params: {})
      uri_builder = UriBuilder.new(primary_endpoint, endpoint, params, { project_id: @configuration.project })

      uri = URI.parse(uri_builder.to_s)

      uri.open('X-TrackerToken' => @configuration.token) do |f|
        JSON.parse(f.read)
      end

    rescue OpenURI::HTTPError => error
      if error.io.status.first == "400"
        response = JSON.parse(error.io.string)
        raise ::Pivotal::ApiError.new(code: response.fetch("code"),
                                      kind: response.fetch("kind"),
                                      error: response.fetch("error"),
                                      general_problem: response.fetch("general_problem"))
      else
        raise
      end
    end
  end
end
