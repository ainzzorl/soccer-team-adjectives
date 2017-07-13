# Filter out blacklisted adjectives.

require 'json'
require 'yaml'

Dir[File.dirname(__FILE__) + '/../../lib/entity_adjectives/*.rb'].each { |file| require file }

data = JSON.parse(ARGF.read)

config = YAML.load_file('./config/teams.yaml')['config']

filter = EntityAdjectives::AdjectiveFilter.new(config)

data.keys.each do |entity|
  data[entity].reject! do |entry|
    filter.exclude?(entry['adjective'])
  end
end

puts JSON.pretty_generate(data)
