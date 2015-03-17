require 'spec_helper'

describe Pivotal::Operations do
  describe '#stories' do
    it 'returns an array of stories' do
      instance = Test::Pivotal::Operations.new(configuration: configuration)

      stories = instance.stories(limit: 1)

      expect(stories).to be_kind_of(Array)
      expect(stories.count).to eq(1)
    end

    it 'applies a filter' do
      instance = Test::Pivotal::Operations.new(configuration: configuration)

      stories = instance.stories(
        fields: [:story_type, :current_state],
        conditions: { with_state: [:accepted] })

      expect(stories.first.keys).to match_array(['id', 'story_type', 'current_state'])
      expect(stories.first['current_state']).to eq('accepted')
    end

    it 'raises an exception with invalid filters' do
      instance = Test::Pivotal::Operations.new(configuration: configuration)

      expect do
        instance.stories(
          fields: [:story_type, :current_state],
          conditions: { with_state: [:accepted] },
          filters: { id: [1] })

      end.to raise_exception(Pivotal::ApiError,
                             'The \'filter\' parameter cannot be combined with other url parameters.')
    end
  end

  describe '#iterations' do
    it 'returns an array of iterations' do
      instance = Test::Pivotal::Operations.new(configuration: configuration)

      iterations = instance.iterations(offset: 88)

      expect(iterations).to be_kind_of(Array)
      expect(iterations.first.keys).to include('stories', 'kind')
      expect(iterations.first.fetch('kind')).to eq('iteration')
    end
  end

  def configuration
    # Using Gov.co.uk pivotal tracker ;)
    double('pivotal_configuration', project: '367813', token: '')
  end
end
