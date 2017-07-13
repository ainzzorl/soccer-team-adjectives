# Take top N adjectives for each entity.

require 'json'
require 'yaml'

config = YAML.load_file('./config/teams.yaml')['config']

data = JSON.parse(ARGF.read)

data.keys.each do |entity|
  data[entity] = data[entity].first(config['max_adjectives_per_entity'])
end

puts JSON.pretty_generate(data)
