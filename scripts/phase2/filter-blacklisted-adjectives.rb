require 'json'
require 'yaml'

Dir[File.dirname(__FILE__) + '/../../lib/soccer_team_adjectives/*.rb'].each { |file| require file }

data = JSON.parse(IO.read('./tmp/phase1/reduced.json'))

config = YAML.load_file './config/config.yaml'

filter = SoccerTeamAdjectives::AdjectiveFilter.new(config)

data.keys.each do |team|
  data[team].reject! do |entry|
    filter.exclude?(entry['adjective'])
  end
end

File.open('./tmp/phase2/after-filter.dat', 'w').puts JSON.pretty_generate(data)
