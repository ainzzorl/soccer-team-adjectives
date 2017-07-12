# For each comment in the data set
# find out what entities are mentioned in it and what adjectives are used around them.
#
# This is by far the slowest step in the entire process.
# It can be parallelized if it becomes too slow.

require 'yaml'
require 'set'
require 'json'
require 'csv'

Dir[File.dirname(__FILE__) + '/../../lib/entity_adjectives/*.rb'].each { |file| require file }

unless ARGV.length == 1
  puts 'Usage: map.rb <path-to-input-file>'
  puts 'The file must be a .csv with comment body in the first column and comment id in the second.'
  exit 1
end

input_file_path = ARGV[0]
OUTPUT_FILE_PATH = './output/phase1/mapped.dat'.freeze

entity_name_extractor = EntityAdjectives::EntityNameExtractor.new(YAML.load_file('./config/teams.yaml'))
comment_data_extractor = EntityAdjectives::CommentDataExtractor.new(entity_name_extractor)

output_file = File.open(OUTPUT_FILE_PATH, 'w')

# Reading the entire dataset at once rather than per row
# because it allows to show the progress.
# Note that a comment can span over more than one line in the file,
# so can't use something like wc to find out the total number of comments in the dataset.
# The entire dataset is less than 1G and fits comfortably in RAM.
csv_rows = CSV.read(input_file_path)
total_comments = csv_rows.size

start_time = Time.now
csv_rows.each_with_index do |comment, comment_index|
  if (comment_index % 1000).zero?
    puts "Line #{comment_index}/#{total_comments}, #{(comment_index * 100.to_f / total_comments).round(2)}%," \
      " time elapsed: #{Time.now - start_time}"
  end

  result = comment_data_extractor.extract(comment[1], comment[0])
  output_file.puts(result.to_json) unless result[:entity_adjectives].empty?
end

output_file.close
