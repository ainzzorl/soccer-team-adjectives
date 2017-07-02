require 'json'
require 'yaml'

LIMIT = 100

Dir[File.dirname(__FILE__) + '/../../lib/soccer_team_adjectives/*.rb'].each { |file| require file }

data = JSON.parse(ARGF.read)

adjective_counts = {}

data.keys.each do |team|
  data[team].each do |p|
    adjective = p['adjective']
    count = p['count']
    adjective_counts[adjective] = 0 unless adjective_counts.key?(adjective)
    adjective_counts[adjective] = adjective_counts[adjective] + count
  end
end

common_adjectives = adjective_counts.sort { |a, b| b[1] <=> a[1] }.map { |a| a[0] }.take(LIMIT)

data.keys.each do |team|
  data[team].reject! do |entry|
    common_adjectives.include?(entry['adjective'])
  end
end

puts JSON.pretty_generate(data)
