require 'json'
require 'yaml'

Dir[File.dirname(__FILE__) + '/../../lib/soccer_team_adjectives/*.rb'].each { |file| require file }

data = JSON.parse(ARGF.read)

config = YAML.load_file './config/config.yaml'

filter = SoccerTeamAdjectives::AdjectiveFilter.new(config)

data.keys.each do |team|
  data[team].reject! do |entry|
    filter.exclude?(entry['adjective'])
  end
end

puts JSON.pretty_generate(data)
