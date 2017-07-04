module SoccerTeamAdjectives
  # Extract team names from a segment.
  class TeamNameExtractor
    SPECIAL_CASE_WORDS = %w[real nice city united].to_set

    def initialize(team_data)
      build_team_name_map(team_data)
    end

    def extract(segment)
      segment.tokenize # This line is slower than everything else combined.
      result = Set.new
      ngram_map = get_ngrams(segment, 3) # MapnN->[list of n-grams]
      word_set = ngram_map[1].map(&:downcase).to_set
      ngram_map.values.each do |ngrams|
        ngrams.each_with_index do |ngram, index|
          downcased = ngram.downcase
          next unless @team_name_map.key?(downcased)
          if SPECIAL_CASE_WORDS.include?(downcased)
            res = extract_special_case(ngram, index, word_set)
            result.add(res) unless res.nil?
          else
            result.add(@team_name_map[downcased])
          end
        end
      end
      result
    end

    private

    def get_ngrams(segment, maxn)
      (1..maxn).map do |n|
        current = []
        result = []
        segment.words.each_with_index do |word, index|
          current.shift if index >= n
          current << word
          result << current.join(' ') if index >= n - 1
        end
        [n, result]
      end.to_h
    end

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
