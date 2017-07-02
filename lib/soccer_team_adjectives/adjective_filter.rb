module SoccerTeamAdjectives
  # Determines adjectives that must be excluded from the result.
  class AdjectiveFilter
    BLACKLIST = %w[
      spanish german english french italian russian chinese american
      austrian canadian turkish bulgarian brazilian colombian
    ].freeze
    SCORE_REGEX = Regexp.new('^[0-9]+-[0-9]+$').freeze
    NUMERIC_ORDER_REGEX = Regexp.new('^[0-9]+(th|st|nd|rd)$').freeze

    def exclude?(adjective)
      blacklisted?(adjective) || score?(adjective) || numeric_order?(adjective)
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

    # rubocop:disable DoubleNegation
    def numeric_order?(adjective)
      !!(adjective =~ NUMERIC_ORDER_REGEX)
    end
    # rubocop:enable DoubleNegation
  end
end
