require 'json'
require 'yaml'

config = YAML.load_file './config/config.yaml'

data = JSON.parse(ARGF.read)

data.keys.each do |team|
  data[team].reject! do |entry|
    entry['count'] < config['min_count']
  end
end

puts JSON.pretty_generate(data)
