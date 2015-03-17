require_relative 'minutes_contract'

module Pivotal
  module Configuration
    class Minutes
      attr_reader :usual_attendees, :email

      def initialize(usual_attendees: raise, email: raise)
        @usual_attendees= usual_attendees
        @email = email
        @validator = MinutesContract.new(self)
      end

      def valid?
        @validator.valid?
      end

      def save!
        raise @validator.errors.contract.messages.inspect unless @validator.valid?

        Repository.store(:minutes, self)
      end

      def self.create!(usual_attendees: raise, email: raise)
        new(usual_attendees: usual_attendees, email: email).tap { |conf| conf.save! }
      end
    end

    class Email
      attr_reader :from, :to, :subject, :mailgun_configuration

      def initialize(from: raise, to: raise, subject: raise, mailgun_configuration: raise)
        @from = from
        @to = to
        @subject = subject
        @mailgun_configuration = mailgun_configuration
      end

      def save!
        Repository.store(:email, self)
      end

      def self.create!(from: raise, to: raise, subject: raise, mailgun_configuration: raise)
        new(from: from,
            to: to,
            subject: subject,
            mailgun_configuration: mailgun_configuration).tap { |conf| conf.save! }
      end
    end

    class Mailgun
      attr_reader :domain, :key

      def initialize(domain: raise, key: raise)
        @domain = domain
        @key = key
      end

      def save!
        Repository.store(:mailgun, self)
      end

      def self.create!(domain: raise, key: raise)
        new(domain: domain, key: key).tap { |conf| conf.save! }
      end
    end
  end
end
