require 'yaml'

RSpec.describe SoccerTeamAdjectives::CommentDataExtractor do
  let(:team_data) { YAML.load_file './config/teams.yaml' }

  let(:team_name_extractor) { SoccerTeamAdjectives::TeamNameExtractor.new(team_data) }

  let(:extractor) { SoccerTeamAdjectives::CommentDataExtractor.new(team_name_extractor) }

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
          team_adjectives:
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
        expect(result).to eq(comment_id: 'comment-id', team_adjectives: {})
      end
    end

    context 'there is team and no adjectives' do
      let(:comment_body) { 'Barcelona with no adjectives' }

      it 'extracts data' do
        expect(result).to eq(comment_id: 'comment-id', team_adjectives: {})
      end
    end
  end
end
