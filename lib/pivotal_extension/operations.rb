require 'open-uri'
require 'json'

module Pivotal
  class Operations
    def initialize(configuration: raise)
      @configuration = configuration
    end

    def stories(filter = {})
      fetch_project_api(endpoint: "stories", params: { limit: 500 }.merge(filter))
    end

    def iterations(filter = {})
      fetch_project_api(endpoint: "iterations", params: filter)
    end

    def project
      fetch_project_api
    end

    def project_name
      project['name']
    end

    protected

    def build_string_filter(params)
      return params if params.instance_of? String
      unless params.instance_of? Hash
        raise "Can't create filter from: #{params.class.to_s}"
      end

      result = []

      result << "limit=#{params.fetch(:limit)}" if params[:limit]
      result << "offset=#{params.fetch(:offset)}" if params[:offset]

      if params[:fields]
        result << "fields=" + (params.fetch(:fields, []).join('%2C'))
      end

      if params[:conditions]
        params.fetch(:conditions, []).each do |field, values|
          result << "#{field.to_s}=#{values.join(',')}"
        end
      end

      if params[:filters]
        result << "filter=" + params.fetch(:filters, {}).map do |filter, values|
          "#{filter}:#{values.join(',')}"
        end.join(' ')
      end

      result.join("&")
    end

    def fetch_project_api(endpoint: nil, params: {})
      string_params = build_string_filter(params)
      uri_string = "https://www.pivotaltracker.com/services/v5/projects/#{@configuration.project}"
      uri_string.concat "/#{endpoint}" if endpoint
      uri_string.concat "?#{string_params}" if endpoint && string_params

      uri = URI.parse(uri_string)

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
