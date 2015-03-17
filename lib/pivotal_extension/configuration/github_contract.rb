require 'reform'

module Pivotal
  module Configuration
    class GithubContract < Reform::Contract
      property :token
      property :repository

      validates :token, presence: true
      validates :repository, presence: true
    end
  end
end
