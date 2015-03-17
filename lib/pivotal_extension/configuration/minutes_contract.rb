require 'reform'

module Pivotal
  module Configuration
    class MinutesContract < Reform::Contract
      property :usual_attendees

      property :email do
        property :from
        property :to
        property :subject

        property :mailgun_configuration do
          property :domain
          property :key

          validates :domain, presence: true
          validates :key, presence: true
        end

        validates :from, presence: true
        validates :to, presence: true
        validates :subject, presence: true
      end

      validates :usual_attendees, presence: true
      validates :email, presence: true
    end
  end
end
