require 'json'
require 'yaml'

Dir[File.dirname(__FILE__) + '/../../lib/soccer_team_adjectives/*.rb'].each { |file| require file }

data = JSON.parse(IO.read('./tmp/phase2/after-filter.dat'))

X = 1.to_f
Y = 1.0

adjectives = {}
total_adjective_count = 0

data.keys.each do |team|
  data[team].each do |p|
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

data.keys.each do |team|
  total_adjective_team_count = data[team].inject(0) { |sum, entry| sum + entry['count'] }
  data[team].each do |entry|
    entry['local_frequency'] = entry['count'].to_f / total_adjective_team_count
    entry['global_frequency'] = adjectives[entry['adjective']][:ratio]
    entry['relative_ratio'] = entry['local_frequency'] / adjectives[entry['adjective']][:ratio]
    entry['score'] = entry['local_frequency'] * X - entry['global_frequency'] * X
  end
  data[team] = data[team].sort_by do |entry|
    -entry['score']
  end
end

File.open('./tmp/phase2/scored.dat', 'w').puts JSON.pretty_generate(data)
