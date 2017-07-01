require 'json'

N = 5

data = JSON.parse(IO.read('./tmp/phase2/after-filter.dat'))

data.keys.each do |team|
  data[team] = data[team].first(N)
end

File.open('./tmp/phase2/top-N.json', 'w').puts JSON.pretty_generate(data)
