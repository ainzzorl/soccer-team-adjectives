module SoccerTeamAdjectives
  # Determines adjectives that must be excluded from the result.
  class AdjectiveFilter
    BLACKLIST = %w[
      spanish german english french italian russian chinese american
      austrian canadian turkish bulgarian brazilian colombian
    ].freeze

    REGEX_BLACKLIST = [
      Regexp.new('^[0-9]+(th|st|nd|rd)$').freeze,
      Regexp.new('^(?!.*[a-zA-Z]).*$').freeze
    ].freeze

    def exclude?(adjective)
      blacklisted?(adjective) || blacklisted_by_regex?(adjective)
    end

    private

    def blacklisted?(adjective)
      BLACKLIST.include?(adjective)
    end

    # rubocop:disable DoubleNegation
    def blacklisted_by_regex?(adjective)
      REGEX_BLACKLIST.any? { |r| !!(adjective =~ r) }
    end
    # rubocop:enable DoubleNegation
  end
end
