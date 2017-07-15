# Filter out adjectives with low counts.

module SoccerAdjectives
  module Phase2
    def self.filter_low_count_adjectives(args)
      config = YAML.load_file('./config/teams.yaml')['config']

      data = args[:data]

      data.keys.each do |entity|
        data[entity].reject! do |entry|
          entry['count'] < config['min_count']
        end
      end
    end
  end
end
