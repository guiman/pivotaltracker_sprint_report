require_relative 'trello_contract'

module Pivotal
  module Configuration
    class Trello
      attr_reader :key, :member_token, :board

      def initialize(key: raise, member_token: raise, board: raise)
        @key = key
        @member_token = member_token
        @board = board
        @validator = TrelloContract.new(self)
      end

      def valid?
        @validator.validate
      end

      def save!
        raise @validator.errors.contract.messages.inspect unless @validator.valid?

        Repository.store(:trello, self)
      end

      def self.create!(key: raise, member_token: raise, board: raise)
        new(key: key, member_token: member_token, board: board).tap { |conf| conf.save! }
      end
    end
  end
end
