require 'json'

N = 5

data = JSON.parse(ARGF.read)

data.keys.each do |team|
  data[team] = data[team].first(N)
end

puts JSON.pretty_generate(data)
