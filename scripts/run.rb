#!/usr/bin/env ruby

require 'fileutils'

unless ARGV.length == 1
  puts 'Usage: phase1.rb <path-to-input-file>'
  puts 'The file must be a .csv with comment body in the first column and comment id in the second.'
  exit 1
end

input_file_path = ARGV[0]

FileUtils.mkdir_p './output/phase1'
FileUtils.mkdir_p './output/phase2'
FileUtils.mkdir_p './output/phase3'

system 'bundle install'

system "./scripts/phase1.rb #{input_file_path}"
system './scripts/phase2.rb'
system './scripts/phase3.rb'

puts 'Done! The results are in ./output/phase3/'
