module SoccerTeamAdjectives
  # Extract team names from a segment.
  class TeamNameExtractor
    SPECIAL_CASE_WORDS = %w[real nice city united].to_set

    def initialize(team_data)
      build_team_name_map(team_data)
    end

    # TODO: cleanup and delete the exception.
    # rubocop:disable MethodLength
    # rubocop:disable PerceivedComplexity
    # rubocop:disable AbcSize
    def extract(segment)
      segment.tokenize
      teams = Set.new
      word_index = 0
      last_two_words = []
      last_three_words = []
      word_set = segment.words.map { |w| w.to_s.downcase }.to_set.inspect
      segment.each_word do |w|
        word = w.to_s.downcase
        last_two_words.shift if word_index > 1
        last_three_words.shift if word_index > 2
        last_two_words << word
        last_three_words << word
        if @team_name_map.key?(word)
          if SPECIAL_CASE_WORDS.include?(word)
            result = extract_special_case(w.to_s, word_index, word_set)
            teams.add(result) unless result.nil?
          else
            teams.add(@team_name_map[word])
          end
        end
        if word_index > 0 && @team_name_map.key?(last_two_words.join(' '))
          teams.add(@team_name_map[last_two_words.join(' ')])
        end
        if word_index > 1 && @team_name_map.key?(last_three_words.join(' '))
          teams.add(@team_name_map[last_three_words.join(' ')])
        end
        word_index += 1
      end
      teams
    end
    # rubocop:enable AbcSize
    # rubocop:enable PerceivedComplexity
    # rubocop:enable MethodLength

    private

    def capitalized?(word)
      word.to_s.capitalize == word.to_s
    end

    def build_team_name_map(team_data)
      @team_name_map = {}
      team_data.each do |team|
        @team_name_map[team['canonical_name'].downcase] = team['canonical_name']
        team['alternative_names'].each do |alt|
          @team_name_map[alt.downcase] = team['canonical_name']
        end
      end
    end

    # Special case handling.
    # In the data set "united" usually mean "Manchester United",
    # but it could be another team like "Newcastle United",
    # or an entity like "United States" or just an adjective like in "they are now united".
    #
    # We assume that if it's a team's name then it should be capitalized.
    # Excluding first words of sentences since they almost always are capitalized.
    # Also assuming it's not the team if words indicating otherwise are present.
    #
    # Precision appears to be decent, recall is adequate.
    # Precision is much more important in this case.
    def extract_special_case(word, word_index, word_set)
      return nil if word_index.zero? || !capitalized?(word)

      case word.downcase
      when 'real'
        @team_name_map['real'] unless %w[betis sociedad salt].any? { |o| word_set.include?(o) }
      when 'nice'
        @team_name_map['nice']
      when 'city'
        @team_name_map['manchester city'] unless %w[york orlando kansas stoke melbourne oklahoma hull]
                                                 .any? { |o| word_set.include?(o) }
      when 'united'
        @team_name_map['manchester united'] unless %w[newcastle airline airlines atlanta dc
                                                      states kingdom minnesota sutton]
                                                   .any? { |o| word_set.include?(o) }
      end
    end
  end
end
