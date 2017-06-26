#!/usr/bin/env ruby

require 'json'

Dir[File.dirname(__FILE__) + '/../../lib/soccer_team_adjectives/*.rb'].each { |file| require file }

common_adjectives = File.open('./tmp/phase2/most-common-adjectives.dat').readlines.map do |l|
  l.sub("\n", '')
end
data = JSON.parse(IO.read('./tmp/phase1/reduced.json'))

filter = SoccerTeamAdjectives::AdjectiveFilter.new

data.keys.each do |team|
  data[team].reject! do |entry|
    common_adjectives.include?(entry['adjective']) || filter.exclude?(entry['adjective'])
  end
end

File.open('./tmp/phase2/after-filter.dat', 'w').puts JSON.pretty_generate(data)
