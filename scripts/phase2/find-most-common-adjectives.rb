#!/usr/bin/env ruby

require 'json'

LIMIT = 100

data = JSON.parse(IO.read('./tmp/phase1/reduced.json'))

adjective_counts = {}

data.keys.each do |team|
  data[team].each do |p|
    adjective = p['adjective']
    count = p['count']
    adjective_counts[adjective] = 0 unless adjective_counts.key?(adjective)
    adjective_counts[adjective] = adjective_counts[adjective] + count
  end
end

File.open('./tmp/phase2/most-common-adjectives.dat', 'w').puts adjective_counts.sort { |a,b| b[1]<=>a[1] }.map { |a| a[0] }.take(LIMIT)
