#!/usr/bin/env ruby

require 'fileutils'

Dir[File.dirname(__FILE__) + '/../lib/entity_adjectives/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/phase1/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/phase2/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/phase3/*.rb'].each { |file| require file }

include SoccerAdjectives

# TODO: allow specifying the phase to run.
# TODO: allow specifying the config.
unless ARGV.length == 1
  puts 'Usage: phase1.rb <path-to-input-file>'
  puts 'The file must be a .csv with comment body in the first column and comment id in the second.'
  exit 1
end

config_file = YAML.load_file './config/teams.yaml'
config = config_file['config']

args = {
  input_file_path: ARGV[0],
  config: config,
  entity_definitions: config_file['entities']
}

FileUtils.mkdir_p './output/phase1'
FileUtils.mkdir_p './output/phase2'
FileUtils.mkdir_p './output/phase3'

system 'bundle install'

Phase1.map args
Phase1.reduce

args[:data] = JSON.parse(File.read('./output/phase1/reduced.json'))

config['sequence']['phase2'].each do |e|
  method = e.tr('-', '_')
  Phase2.send method, args
end

Phase3.export args

puts 'Done! The results are in ./output/phase3/'
