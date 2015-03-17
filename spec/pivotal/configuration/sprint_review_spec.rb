require 'spec_helper'

describe Pivotal::Configuration::SprintReview do
  describe "save!" do
    subject { described_class.new(team_members: double) }

    it "stores the new configuration" do
      subject.save!

      expect(Pivotal::Configuration::Repository.get(:sprint_review)).to eq(subject)
    end
  end

  describe "create!" do
    it "returns an instance" do
      expect(described_class.create!(team_members: double)).to be_instance_of described_class
    end

    it "stores the new configuration" do
      new_instance = described_class.create!(team_members: double)

      expect(Pivotal::Configuration::Repository.get(:sprint_review)).to eq(new_instance)
    end
  end
end
