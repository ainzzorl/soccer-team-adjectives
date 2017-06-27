RSpec.describe SoccerTeamAdjectives::AdjectiveFilter do
  let(:filter) { SoccerTeamAdjectives::AdjectiveFilter.new }

  describe 'exclude?' do
    it 'excludes national adjectives' do
      %w[spanish german english french italian russian].each { |a| expect(filter.exclude?(a)).to be true }
    end

    it 'excludes scores' do
      %w[1-1 7-3 0-0 11-12].each { |a| expect(filter.exclude?(a)).to be true }
    end

    it 'excludes numeric orders' do
      %w[4th 9th 11th 1st 2nd 3rd].each { |a| expect(filter.exclude?(a)).to be true }
    end

    it 'does not exclude non-blacklisted words' do
      %w[good bad normal].each { |a| expect(filter.exclude?(a)).to be false }
    end
  end
end
