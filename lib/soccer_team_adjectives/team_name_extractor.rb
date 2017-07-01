module SoccerTeamAdjectives
  # Extract team names from a segment.
  class TeamNameExtractor
    def initialize(team_name_map, common_word_team_names)
      @team_name_map = team_name_map
      @common_word_team_names = common_word_team_names.to_set
    end

    # TODO: cleanup and delete the exception.
    # rubocop:disable MethodLength
    # rubocop:disable CyclomaticComplexity
    # rubocop:disable PerceivedComplexity
    # rubocop:disable AbcSize
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
          teams.add(@team_name_map[word]) unless
            @common_word_team_names.include?(word) && (!capitalized?(w) || word_index.zero?)
        elsif word_index > 0 && @team_name_map.key?(last_two_words.join(' '))
          teams.add(@team_name_map[last_two_words.join(' ')])
        elsif word_index > 1 && @team_name_map.key?(last_three_words.join(' '))
          teams.add(@team_name_map[last_three_words.join(' ')])
        end
        word_index += 1
      end
      teams
    end
    # rubocop:enable AbcSize
    # rubocop:enable PerceivedComplexity
    # rubocop:enable CyclomaticComplexity
    # rubocop:enable MethodLength

    private

    def capitalized?(word)
      word.to_s.capitalize == word.to_s
    end
  end
end
