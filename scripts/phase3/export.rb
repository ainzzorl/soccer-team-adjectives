require 'json'
require 'yaml'

# Export results to .csv
module SoccerAdjectives
  module Phase3
    def self.export(args)
      config_file = YAML.load_file './config/teams.yaml'

      config = config_file['config']

      entities = config_file['entities']

      data = args[:data]

      leagues = entities.map { |t| t['league'] }.uniq

      leagues.each do |league|
        file = File.open("./output/phase3/#{league}.csv", 'w')
        league_entities = entities.select { |t| t['league'] == league }.sort_by { |t| t['canonical_name'] }
        league_entities.each do |entity|
          entity_data = data.key?(entity['canonical_name']) ? data[entity['canonical_name']] : []
          adjectives = entity_data.map { |e| e['adjective'] }
          adjectives.push('N/A') while adjectives.size < config['max_adjectives_per_entity']
          file.puts(entity['canonical_name'] + ';' + adjectives.join(';'))
        end
      end
    end
  end
end
