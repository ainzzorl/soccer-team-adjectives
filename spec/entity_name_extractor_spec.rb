require 'yaml'
require 'treat'
include Treat::Core::DSL

RSpec.describe EntityAdjectives::EntityNameExtractor do
  let(:entity_data) { YAML.load_file('./config/teams.yaml')['entities'] }

  let(:extractor) { EntityAdjectives::EntityNameExtractor.new(entity_data) }

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

    it 'extracts multiple entitites' do
      expect(extractor.extract(sentence('Prefix Torino Middle Udinese Postfix')).to_a).to eq(%w[Torino Udinese])
    end

    it 'extracts nothing if there\'s nothing' do
      expect(extractor.extract(sentence('Prefix Middle Postfix')).to_a).to eq([])
    end

    context 'special cases' do
      context 'Real' do
        it 'extracts capitalized matches from middle' do
          expect(extractor.extract(sentence('Ronaldo playes for Real')).to_a).to eq(['Real Madrid'])
        end

        it 'does not extract non-capitalized matches' do
          expect(extractor.extract(sentence('The pain is real')).to_a).to eq([])
        end

        it 'does not extract capitalized matches from the beginning' do
          expect(extractor.extract(sentence('Real can mean the entity or not')).to_a).to eq([])
        end

        it 'extracts the other Real if present' do
          expect(extractor.extract(sentence('He is playing for Real Sociedad')).to_a).to eq(['Real Sociedad'])
        end
      end

      context 'United' do
        it 'extracts capitalized matches from middle' do
          expect(extractor.extract(sentence('He is a United fan')).to_a).to eq(['Manchester United'])
        end

        it 'extracts the other United if present' do
          expect(extractor.extract(sentence('His favorite entity is DC United')).to_a).to eq(['D.C. United'])
        end
      end

      context 'City' do
        it 'extracts capitalized matches from middle' do
          expect(extractor.extract(sentence('She does not like City')).to_a).to eq(['Manchester City'])
        end

        it 'extracts the other City if present' do
          expect(extractor.extract(sentence('How is Stoke City?')).to_a).to eq(['Stoke City'])
        end
      end

      context 'Nice' do
        it 'extracts capitalized matches from middle' do
          expect(extractor.extract(sentence('French entitites like Nice')).to_a).to eq(['Nice'])
        end
      end
    end
  end
end
