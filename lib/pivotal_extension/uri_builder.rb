require 'pivotal_extension/params_builder'

module Pivotal
  class UriBuilder

    HOST="https://www.pivotaltracker.com/services/v5"

    def initialize(primary_endpoint, endpoint, params, interpolations={})
      @primary_endpoint = primary_endpoint
      @endpoint = endpoint
      @params = params
      @interpolations = interpolations
    end

    def params
      ::Pivotal::ParamsBuilder.new(@params)
    end

    def to_s
      uri_string = "#{HOST}#{@primary_endpoint}"

      @interpolations.each do |k,v|
        uri_string.gsub!(":#{k}", v)
      end

      uri_string.concat "/#{@endpoint}" if @endpoint
      uri_string.concat "?#{params.to_s}" if @endpoint && params

      uri_string
    end
  end
end
