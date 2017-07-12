# Score adjectives.
# "Local frequency (adjective, entity)" = count(adjective|entity)/count(all adjectives for the entity)
# "Global frequency (adjective)" = count(adjective|entity)/count(adjective across all entity)
# Score (adjective, entity) = X * (local frequency) + Y * (global frequency)
#
# The higher the local frequency, the more often the adjective is used to describe the entity.
# The higher the global frequency, the more often the adjective is used to describe ANY entity in the data set.
#
# Words with high global frequency tend to be very generic.
# Choose Y < 0 to promote more unusual (and likely more interesting) adjectives.

require 'json'
require 'yaml'

Dir[File.dirname(__FILE__) + '/../../lib/entity_adjectives/*.rb'].each { |file| require file }

config = YAML.load_file './config/config.yaml'

local_frequency_coefficient = config['scoring']['local_frequency_coefficient'].to_f
global_frequency_coefficient = config['scoring']['global_frequency_coefficient'].to_f

data = JSON.parse(ARGF.read)

adjectives = {}
total_adjective_count = 0

data.keys.each do |entity|
  data[entity].each do |p|
    adjective = p['adjective']
    count = p['count']
    total_adjective_count += count
    adjectives[adjective] = { count: 0 } unless adjectives.key?(adjective)
    adjectives[adjective][:count] = adjectives[adjective][:count] + count
  end
end

adjectives.keys.each do |a|
  adjectives[a][:ratio] = adjectives[a][:count].to_f / total_adjective_count
end

data.keys.each do |entity|
  total_adjective_entity_count = data[entity].inject(0) { |sum, entry| sum + entry['count'] }
  data[entity].each do |entry|
    entry['local_frequency'] = entry['count'].to_f / total_adjective_entity_count
    entry['global_frequency'] = adjectives[entry['adjective']][:ratio]
    entry['score'] = entry['local_frequency'] * local_frequency_coefficient +
                     entry['global_frequency'] * global_frequency_coefficient
  end
  data[entity] = data[entity].sort_by do |entry|
    -entry['score']
  end
end

puts JSON.pretty_generate(data)
