#!/usr/bin/env ruby

require 'optparse'
require 'fileutils'

Dir[File.dirname(__FILE__) + '/../lib/entity_adjectives/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/phase1/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/phase2/*.rb'].each { |file| require file }
Dir[File.dirname(__FILE__) + '/phase3/*.rb'].each { |file| require file }

include SoccerAdjectives

options = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: run.rb --input-file INPUT-FILE --config-file CONFIG-FILE [--stages STAGES]'
  opt.on('-i', '--input-file INPUT-FILE') { |o| options[:input_file_path] = o }
  opt.on('-c', '--config-file CONFIG-FILE') { |o| options[:config_file_path] = o }
  opt.on('-s', '--stages STAGES') do |o|
    options[:stages] = o.split(',').map do |s|
      raise "Unknown stage: #{s}" unless s.match(/^\d+$/) && s.to_i >= 1 && s.to_i <= 3
      s.to_i
    end.to_set
  end
end
opt_parser.parse!

required_options = %i[input_file_path config_file_path]
if required_options.any? { |o| options[o].nil? }
  puts opt_parser.banner
  exit 1
end

config_file = YAML.load_file options[:config_file_path]
config = config_file['config']

args = {
  input_file_path: options[:input_file_path],
  config: config,
  entity_definitions: config_file['entities']
}

FileUtils.mkdir_p './output/phase1'
FileUtils.mkdir_p './output/phase2'
FileUtils.mkdir_p './output/phase3'

system 'bundle install'

if options[:stages].include?(1)
  Phase1.map args
  Phase1.reduce
end

if options[:stages].include?(2)
  args[:data] = JSON.parse(File.read('./output/phase1/reduced.json'))

  config['sequence']['phase2'].each do |e|
    method = e.tr('-', '_')
    Phase2.send method, args
  end
end

if options[:stages].include?(3)
  Phase3.export args
  puts 'Done! The results are in ./output/phase3/'
end
