require_relative 'pivotal_contract'

module Pivotal
  module Configuration
    class Pivotal
      attr_reader :token, :project

      def initialize(token: raise, project: raise)
        @token = token
        @project = project
        @validator = PivotalContract.new(self)
      end

      def valid?
        @validator.valid?
      end

      def save!
        raise @validator.errors.contract.messages.inspect unless @validator.valid?

        Repository.store(:pivotal, self)
      end

      def self.create!(token: raise, project: raise)
        new(token: token, project: project).tap do |conf|
          conf.save!
        end
      end
    end
  end
end
