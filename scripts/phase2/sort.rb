require 'json'

data = JSON.parse(IO.read('./tmp/phase2/top-N.json'))

data = data.sort_by do |_, adjectives|
  -adjectives
    .map { |a| a['count'] }
    .inject(0) { |sum, c| sum + c }
end

File.open('./tmp/phase2/sorted.json', 'w').puts JSON.pretty_generate(data)
