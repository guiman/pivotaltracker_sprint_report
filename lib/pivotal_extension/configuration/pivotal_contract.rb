require 'reform'

module Pivotal
  class PivotalContract < Reform::Contract
    property :token
    property :project

    validates :token, presence: true
    validates :project, presence: true
  end
end
