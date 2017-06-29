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
      'teamtwopartone teamtwoparttwo teamtwopartthree' => 'teamtwo'
    }
  end

  let(:extractor) { SoccerTeamAdjectives::TeamNameExtractor.new(team_name_map) }

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
  end
end
