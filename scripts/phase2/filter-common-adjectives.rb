# Filter out most common adjectives.

module SoccerAdjectives
  module Phase2
    def self.filter_common_adjectives(args)
      config = args[:config]
      data = args[:data]

      adjective_counts = {}

      data.keys.each do |entity|
        data[entity].each do |p|
          adjective = p['adjective']
          count = p['count']
          adjective_counts[adjective] = 0 unless adjective_counts.key?(adjective)
          adjective_counts[adjective] = adjective_counts[adjective] + count
        end
      end

      common_adjectives = adjective_counts
                          .sort { |a, b| b[1] <=> a[1] }
                          .map { |a| a[0] }
                          .take(config['common_adjectives_to_exclude'])

      data.keys.each do |entity|
        data[entity].reject! do |entry|
          common_adjectives.include?(entry['adjective'])
        end
      end
    end
  end
end
