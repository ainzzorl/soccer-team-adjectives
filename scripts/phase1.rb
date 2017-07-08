#!/usr/bin/env ruby

unless ARGV.length == 1
  puts 'Usage: phase1.rb <path-to-input-file>'
  puts 'The file must be a .csv with comment body in the first column and comment id in the second.'
  exit 1
end

input_file_path = ARGV[0]

system "bundle exec ruby ./scripts/phase1/map.rb #{input_file_path}"
system 'bundle exec ruby ./scripts/phase1/reduce.rb'
