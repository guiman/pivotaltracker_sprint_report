require 'spec_helper'

describe Pivotal::Configuration::Pivotal do
  describe "save!" do
    subject { described_class.new(token: double, project: double) }

    it "stores the new configuration" do
      subject.save!

      expect(Pivotal::Configuration::Repository.get(:pivotal)).to eq(subject)
    end
  end

  describe "create!" do
    it "returns an instance" do
      expect(described_class.create!(token: double, project: double)).to be_instance_of described_class
    end

    it "stores the new configuration" do
      new_instance = described_class.create!(token: double, project: double)

      expect(Pivotal::Configuration::Repository.get(:pivotal)).to eq(new_instance)
    end
  end
end
