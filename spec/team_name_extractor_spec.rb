require 'treat'
include Treat::Core::DSL

RSpec.describe SoccerTeamAdjectives::TeamNameExtractor do
  let(:team_name_map) do
    {
      'teamonefull' => 'teamone',
      'teamonepartone teamoneparttwo' => 'teamone',
      'teamonepartone teamoneparttwo teamonepartthree' => 'teamone',
      'teamtwofull' => 'teamtwo',
      'teamtwopartone teamtwoparttwo' => 'teamtwo',
      'teamtwopartone teamtwoparttwo teamtwopartthree' => 'teamtwo',
      'real' => 'Real Madrid'
    }
  end

  let(:common_word_team_names) { %w[real city nice] }

  let(:extractor) { SoccerTeamAdjectives::TeamNameExtractor.new(team_name_map, common_word_team_names) }

  describe 'extract' do
    it 'extracts 1 word matches' do
      expect(extractor.extract(sentence('Prefix TeamoneFull Postfix')).to_a).to eq(['teamone'])
    end

    it 'extracts 2 word matches' do
      expect(extractor.extract(sentence('Prefix TeamonePartone TeamoneParttwo Postfix')).to_a).to eq(['teamone'])
    end

    it 'extracts 3 word matches' do
      expect(extractor.extract(sentence('Prefix TeamonePartone TeamoneParttwo TeamonePartthree Postfix')).to_a)
        .to eq(['teamone'])
    end

    it 'extracts multiple teams' do
      expect(extractor.extract(sentence('Prefix TeamoneFull Middle TeamtwoFull Postfix')).to_a)
        .to eq(%w[teamone teamtwo])
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
