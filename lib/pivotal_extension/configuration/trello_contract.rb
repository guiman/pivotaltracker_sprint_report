require 'reform'

class TrelloContract < Reform::Contract
  property :key
  property :member_token
  property :board

  validates :key, presence: true
  validates :member_token, presence: true
  validates :board, presence: true
end
