require_relative 'sprint_review_contract'

module Pivotal
  class SprintReview
    attr_reader :iteration_number, :iterations

    def self.from_hash(params: raise, pivotal_operations: raise)
      new(iteration: params.fetch('iteration'),
          pivotal_operations: pivotal_operations)
    end

    def initialize(iteration: raise, pivotal_operations: raise, contract: SprintReviewContract)
      @iteration_number = iteration
      @pivotal_operations = pivotal_operations
      @validator = contract.new(self)

      if valid?
        offset = @iteration_number.to_i - 1
        @iterations = @pivotal_operations.iterations(offset: offset)
      end
    end

    def valid?
      @validator.validate
    end

    def name
      "Sprint #{@iteration_number} - #{@pivotal_operations.project.fetch("name")}"
    end

    def from
      DateTime.parse(@iterations.first.fetch("start")).to_date.strftime("%e %b")
    end

    def to
      DateTime.parse(@iterations.first.fetch("finish")).to_date.strftime("%e %b")
    end

    def points_completed
      @iterations.first.fetch("stories").select { |story| story["current_state"] == "accepted" }.inject(0) { |sum, story|  sum += story.fetch("estimate", 0) }
    end

    def chore_and_bugs
      @iterations.first.fetch("stories").select { |story| ["chore", "bug"].include? story["story_type"] }
    end

    def in_progress
      block = Proc.new { |story| ["started", "finished", "delivered", "rejected"].include? story["current_state"]  }
      @iterations.first.fetch("stories").select(&block) | @iterations.last.fetch("stories").select(&block)
    end

    def all_stories
      iterations.first.fetch("stories") | (in_progress)
    end

    def icebox
      @pivotal_operations.stories(conditions: { with_state: [:unscheduled] })
    end
  end
end
