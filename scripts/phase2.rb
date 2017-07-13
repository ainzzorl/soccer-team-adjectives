#!/usr/bin/env ruby

require 'yaml'

config = YAML.load_file('./config/teams.yaml')['config']

command = 'cat ./output/phase1/reduced.json |'

config['sequence']['phase2'].each do |e|
  command += "bundle exec ruby ./scripts/phase2/#{e}.rb |"
end

command += 'cat > output/phase2/result.dat'

system command
