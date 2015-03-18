module Pivotal
  class ParamsBuilder

    AVAILABLE_OPTIONS=[:limit, :offset, :fields, :conditions, :filters]

    def initialize(params = {})
      @params = params
    end

    def to_s
      unless @params.instance_of? Hash
        raise "Can't create params from: #{@params.class.to_s}"
      end

      AVAILABLE_OPTIONS.inject([]) do |res, option|
        if @params.fetch(option, false)
          res << self.public_send(option)
        else
          res
        end
      end.join("&")
    end

    def limit
      "limit=#{@params.fetch(:limit)}"
    end

    def offset
      "offset=#{@params.fetch(:offset)}"
    end

    def fields
      "fields=" + (@params.fetch(:fields, []).join('%2C'))
    end

    def conditions
      @params.fetch(:conditions, []).map do |field, values|
        "#{field.to_s}=#{values.join(',')}"
      end.join("&")
    end

    def filters
      "filter=" + @params.fetch(:filters, {}).map do |filter, values|
        "#{filter}:#{values.join(',')}"
      end.join(' ')
    end
  end
end
