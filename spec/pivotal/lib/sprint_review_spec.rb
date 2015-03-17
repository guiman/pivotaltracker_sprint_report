require 'spec_helper'

describe Pivotal::SprintReview do
  describe '.from_hash' do
    it 'builds an instance from params' do
      params = { 'iteration' => '' }

      instance = described_class.from_hash(params: params,
                                           pivotal_operations: pivotal_operations)

      expect(instance).to be_kind_of(Pivotal::SprintReview)
    end

    context 'any of the params is nil' do
      it 'raises an exception' do
        params = { iteration: '' }

        expect do
          described_class.from_hash(params: params,
                                    pivotal_operations: pivotal_operations)
        end.to raise_error(KeyError)
      end
    end
  end

  describe '#name' do
    it 'shows the iteration number and the project name' do
      instance = described_class.new(
        iteration: 10,
        pivotal_operations: pivotal_operations)

      expect(instance.name).to eq("Sprint 10 - Departments and policy (Dev)")
    end
  end

  describe "#points_completed" do
    it 'calculates points considering accepted stories' do
      instance = described_class.new(
        iteration: 10,
        pivotal_operations: pivotal_operations)

      expect(instance.points_completed).to eq(75)
    end
  end

  describe "#points_completed" do
    it 'calculates points considering accepted chores and bugs' do
      instance = described_class.new(
        iteration: 10,
        pivotal_operations: pivotal_operations)

      expect(instance.chore_and_bugs.count).to eq(22)
    end
  end

  def pivotal_operations
    # Using Gov.co.uk pivotal tracker ;)
    configuration = double('pivotal_configuration', project: '367813', token: '')
    Test::Pivotal::Operations.new(configuration: configuration)
  end
end
