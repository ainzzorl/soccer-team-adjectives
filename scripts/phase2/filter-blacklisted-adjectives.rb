# Filter out blacklisted adjectives.

module SoccerAdjectives
  module Phase2
    def self.filter_blacklisted_adjectives(args)
      data = args[:data]
      config = args[:config]
      filter = EntityAdjectives::AdjectiveFilter.new(config)

      data.keys.each do |entity|
        data[entity].reject! do |entry|
          filter.exclude?(entry['adjective'])
        end
      end
    end
  end
end
