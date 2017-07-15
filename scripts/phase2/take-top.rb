# Take top N adjectives for each entity.

module SoccerAdjectives
  module Phase2
    def self.take_top(args)
      config = args[:config]

      data = args[:data]

      data.keys.each do |entity|
        data[entity] = data[entity].first(config['max_adjectives_per_entity'])
      end
    end
  end
end
