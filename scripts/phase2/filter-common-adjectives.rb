# Filter out most common adjectives.

require 'json'
require 'yaml'

config = YAML.load_file './config/config.yaml'

data = JSON.parse(ARGF.read)

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

puts JSON.pretty_generate(data)
