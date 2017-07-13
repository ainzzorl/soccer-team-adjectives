# Filter out adjectives with low counts.

require 'json'
require 'yaml'

config = YAML.load_file('./config/teams.yaml')['config']

data = JSON.parse(ARGF.read)

data.keys.each do |entity|
  data[entity].reject! do |entry|
    entry['count'] < config['min_count']
  end
end

puts JSON.pretty_generate(data)
