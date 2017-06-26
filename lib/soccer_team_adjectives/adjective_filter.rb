module SoccerTeamAdjectives
  # Determines adjectives that must be excluded from the result.
  class AdjectiveFilter
    BLACKLIST = %w[spanish german english french italian russian].freeze
    SCORE_REGEX = Regexp.new('^[0-9]-[0-9]$').freeze

    def exclude?(adjective)
      blacklisted?(adjective) || score?(adjective)
    end

    private

    def blacklisted?(adjective)
      BLACKLIST.include?(adjective)
    end

    # rubocop:disable DoubleNegation
    def score?(adjective)
      !!(adjective =~ SCORE_REGEX)
    end
    # rubocop:enable DoubleNegation
  end
end
