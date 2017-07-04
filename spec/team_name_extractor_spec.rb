require 'yaml'
require 'treat'
include Treat::Core::DSL

RSpec.describe SoccerTeamAdjectives::TeamNameExtractor do
  let(:team_data) { YAML.load_file './config/teams.yaml' }

  let(:common_word_team_names) { %w[real city nice] }

  let(:extractor) { SoccerTeamAdjectives::TeamNameExtractor.new(team_data, common_word_team_names) }

  describe 'extract' do
    it 'extracts 1 word matches' do
      expect(extractor.extract(sentence('Prexi Bayern Postfix')).to_a).to eq(['Bayern Munich'])
    end

    it 'extracts 2 word matches' do
      expect(extractor.extract(sentence('Prefix Crystal Palace Postfix')).to_a).to eq(['Crystal Palace'])
    end

    it 'extracts 3 word matches' do
      expect(extractor.extract(sentence('Prefix Paris Saint Germain Postfix')).to_a).to eq(['PSG'])
    end

    it 'extracts multiple teams' do
      expect(extractor.extract(sentence('Prefix Torino Middle Udinese Postfix')).to_a).to eq(%w[Torino Udinese])
    end

    it 'extracts nothing if there\'s nothing' do
      expect(extractor.extract(sentence('Prefix Middle Postfix')).to_a).to eq([])
    end

    context 'common word names' do
      it 'extracts capitalized matches from middle' do
        expect(extractor.extract(sentence('Ronaldo playes for Real')).to_a).to eq(['Real Madrid'])
      end

      it 'does not extract non-capitalized matches' do
        expect(extractor.extract(sentence('The pain is real')).to_a).to eq([])
      end

      it 'does not extract capitalized matches from the beginning' do
        expect(extractor.extract(sentence('Real can mean the team or not')).to_a).to eq([])
      end
    end
  end
end
