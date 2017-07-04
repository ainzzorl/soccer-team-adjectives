module SoccerTeamAdjectives
  # Filters out blacklisted adjectives.
  class AdjectiveFilter
    def initialize(config)
      @config = config

      @blacklisted_adjectives = config['blacklisted_adjectives']
      @blacklisted_adjective_patterns = config['blacklisted_adjective_patterns'].map { |p| Regexp.new(p) }
    end

    def exclude?(adjective)
      blacklisted?(adjective) || blacklisted_by_regex?(adjective)
    end

    private

    def blacklisted?(adjective)
      @blacklisted_adjectives.include?(adjective)
    end

    # rubocop:disable DoubleNegation
    def blacklisted_by_regex?(adjective)
      @blacklisted_adjective_patterns.any? { |r| !!(adjective =~ r) }
    end
    # rubocop:enable DoubleNegation
  end
end
