module Pivotal
  class ApiError < StandardError
    attr_reader :code, :kind, :error, :general_problem
    def initialize(code: "", kind: "", error: "", general_problem: "")
      @code = code
      @kind = kind
      @error = error
      @general_problem = general_problem
    end

    def message
      @general_problem
    end
  end
end
