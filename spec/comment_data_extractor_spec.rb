require 'yaml'

RSpec.describe EntityAdjectives::CommentDataExtractor do
  let(:entity_data) { YAML.load_file './config/teams.yaml' }

  let(:entity_name_extractor) { EntityAdjectives::EntityNameExtractor.new(entity_data) }

  let(:extractor) { EntityAdjectives::CommentDataExtractor.new(entity_name_extractor) }

  let(:comment_id) { 'comment-id' }

  let(:result) { extractor.extract(comment_id, comment_body) }

  describe 'extract' do
    context 'there is something' do
      let(:comment_body) do
        'Barcelona good bad good. Arsenal and Chelsea are fine. Barcelona is blue.'
      end

      it 'extracts data' do
        expect(result).to eq(
          comment_id: 'comment-id',
          entity_adjectives:
          {
            'Barcelona' => { 'good' => 2, 'bad' => 1, 'blue' => 1 },
            'Arsenal' => { 'fine' => 1 },
            'Chelsea' => { 'fine' => 1 }
          }
        )
      end
    end

    context 'there is nothing' do
      let(:comment_body) { 'Nothing interesting here' }

      it 'extracts data' do
        expect(result).to eq(comment_id: 'comment-id', entity_adjectives: {})
      end
    end

    context 'there is entity and no adjectives' do
      let(:comment_body) { 'Barcelona with no adjectives' }

      it 'extracts data' do
        expect(result).to eq(comment_id: 'comment-id', entity_adjectives: {})
      end
    end
  end
end
