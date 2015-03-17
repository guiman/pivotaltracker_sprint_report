module Pivotal
  class GithubIntegration
    def initialize(configuration: raise)
      @configuration = configuration
      @client = Octokit::Client.new access_token: configuration.token
    end

    def fetch_description_for(id: raise, fallback_description: raise)
      pull_request = find_pr(id, fetch_pull_requests)
      pull_request = { body: fallback_description } if pull_request.nil?

      description = clean_pull_request_body(pull_request, id)

      description.empty? ? fallback_description : description
    end

    def find_pr(id, pull_requests, retries = 3)
      collection = pull_requests
      pull_request = nil

      retries.times do
        pull_request = collection.detect { |pr| pr[:title] =~ /#{id}/ }

        if !pull_request.nil?
          break(pull_request)
        else
          collection = next_page
        end
      end

      pull_request
    end

    def fetch_pull_requests
      fetch_pull_requests_from_github
    end

    private


    def next_page
      raise "No page to work on" unless client.last_response.rels[:next]
      client.last_response.rels[:next].get.data
    end

    def client
      @client
    end

    def fetch_pull_requests_from_github
      client.pull_requests(@configuration.repository,
                           state: :all,
                           direction: :desc,
                           per_page: 200)
    end

    def clean_pull_request_body(pull_request, id)
      pull_request[:body].gsub(/\[.*\]\(.*\)/, '')
        .gsub(/https\:\/\/ci.hq.noths.com\/job\/.*\//, '')
        .gsub(/^https\:\/\/www.pivotaltracker.com\/story\/show\/#{id}/, '')
        .strip
    end
  end
end
