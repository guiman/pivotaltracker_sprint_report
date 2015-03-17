require_relative 'github_contract'

module Pivotal
  module Configuration
    class Github
      attr_reader :token, :repository

      def initialize(token: raise, repository: raise, validator: GithubContract)
        @token = token
        @repository = repository
        @validator = validator.new(self)
      end

      def valid?
        @validator.validate
      end

      def save!
        raise @validator.errors.contract.messages.inspect unless @validator.valid?

        Repository.store(:github, self)
      end

      def self.create!(token: raise, repository: raise)
        new(token: token, repository: repository).tap do |conf|
          conf.save!
        end
      end
    end
  end
end
