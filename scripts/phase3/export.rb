require 'json'
require 'yaml'

teams = YAML.load_file './config/teams.yaml'

data = JSON.parse(ARGF.read)

leagues = teams.map { |t| t['league'] }.uniq

leagues.each do |league|
  file = File.open("./tmp/phase3/#{league}.csv", 'w')
  league_teams = teams.select { |t| t['league'] == league }.sort_by { |t| t['canonical_name'] }
  league_teams.each do |team|
    team_data = data.key?(team['canonical_name']) ? data[team['canonical_name']] : []
    adjectives = team_data.map { |e| e['adjective'] }
    file.puts(team['canonical_name'] + ';' + adjectives.join(';'))
  end
end
