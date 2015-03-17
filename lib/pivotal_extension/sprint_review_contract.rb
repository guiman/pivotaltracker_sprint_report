class SprintReviewContract < Reform::Contract
  property :iteration_number

  validates :iteration_number, presence: true
end
