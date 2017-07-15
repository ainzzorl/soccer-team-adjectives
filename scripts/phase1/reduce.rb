# Aggregate entity/adjective counts across all comments.

module SoccerAdjectives
  module Phase1
    def self.reduce
      total_counts = {}

      File.open('./output/phase1/mapped.dat').each_line do |line|
        line_counts = JSON.parse(line)['entity_adjectives']
        line_counts.keys.each do |entity|
          total_counts[entity] = {} unless total_counts.key?(entity)
          line_counts[entity].keys.each do |adjective|
            total_counts[entity][adjective] = 0 unless total_counts[entity].key?(adjective)
            total_counts[entity][adjective] += 1
          end
        end
      end

      result = {}

      # Sorting adjectives by count.
      # Unnecessary but makes intermediate results more readable.
      total_counts.keys.each do |entity|
        result[entity] = []
        total_counts[entity].sort { |a, b| b[1] <=> a[1] }.each do |key, value|
          result[entity] << { adjective: key, count: value }
        end
      end

      file = File.open('./output/phase1/reduced.json', 'w')
      file.puts JSON.pretty_generate(result)
      file.close
    end
  end
end
