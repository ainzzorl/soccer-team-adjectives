module SoccerTeamAdjectives
  # Extract team names from a segment.
  class TeamNameExtractor
    def initialize(team_name_map)
      @team_name_map = team_name_map
    end

    # TODO: cleanup and delete the exception.
    # rubocop:disable MethodLength
    def extract(segment)
      segment.tokenize
      teams = Set.new
      word_index = 0
      last_two_words = []
      last_three_words = []
      segment.each_word do |w|
        word = w.to_s.downcase
        last_two_words.shift if word_index > 1
        last_three_words.shift if word_index > 2
        last_two_words << word
        last_three_words << word
        if @team_name_map.key?(word)
          teams.add(@team_name_map[word])
        elsif word_index > 0 && @team_name_map.key?(last_two_words.join(' '))
          teams.add(@team_name_map[last_two_words.join(' ')])
        elsif word_index > 1 && @team_name_map.key?(last_three_words.join(' '))
          teams.add(@team_name_map[last_three_words.join(' ')])
        end
        word_index += 1
      end
      teams
    end
    # rubocop:enable MethodLength
  end
end
