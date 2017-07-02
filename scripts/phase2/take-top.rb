require 'json'
require 'yaml'

config = YAML.load_file './config/config.yaml'

data = JSON.parse(ARGF.read)

data.keys.each do |team|
  data[team] = data[team].first(config['max_adjectives_per_team'])
end

puts JSON.pretty_generate(data)
