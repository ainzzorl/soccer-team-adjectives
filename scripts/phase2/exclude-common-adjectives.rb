#!/usr/bin/env ruby

require 'json'

common_adjectives = File.open('./tmp/phase2/most-common-adjectives.dat').readlines.map do |l|
  l.sub("\n", "")
end
data = JSON.parse(IO.read('./tmp/phase1/reduced.json'))

data.keys.each do |team|
  data[team].select! do |entry|
    !common_adjectives.include?(entry['adjective'])
  end
end

File.open('./tmp/phase2/without-most-common-adjectives.dat', 'w').puts JSON.pretty_generate(data)
