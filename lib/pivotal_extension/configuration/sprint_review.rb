module Pivotal
  module Configuration
    class SprintReview
      attr_reader :team_members

      def initialize(team_members: raise)
        @team_members = team_members
      end

      def save!
        Repository.store(:sprint_review, self)
      end

      def self.create!(team_members: raise)
        new(team_members: team_members).tap { |conf| conf.save! }
      end
    end
  end
end
