# For each comment in the data set
# find out what teams are mentioned in it and what adjectives are used around them.
#
# This is by far the slowest step in the entire process.
# It can be parallelized if it becomes too slow.

require 'yaml'
require 'set'
require 'json'
require 'csv'

Dir[File.dirname(__FILE__) + '/../../lib/soccer_team_adjectives/*.rb'].each { |file| require file }

INPUT_FILE_PATH = './input/soccer_comments_and_ids_2016_11.csv'.freeze
OUTPUT_FILE_PATH = './tmp/phase1/mapped.dat'.freeze

team_name_extractor = SoccerTeamAdjectives::TeamNameExtractor.new(YAML.load_file('./config/teams.yaml'))
comment_data_extractor = SoccerTeamAdjectives::CommentDataExtractor.new(team_name_extractor)

output_file = File.open(OUTPUT_FILE_PATH, 'w')

# Reading the entire dataset at once rather than per row
# because it allows to show the progress.
# Note that a comment can span over more than one line in the file,
# so can't use something like wc to find out the total number of comments in the dataset.
# The entire dataset is less than 1G and fits comfortably in RAM.
csv_rows = CSV.read(INPUT_FILE_PATH)
total_comments = csv_rows.size

start_time = Time.now
csv_rows.each_with_index do |comment, comment_index|
  if (comment_index % 1000).zero?
    puts "Line #{comment_index}/#{total_comments}, #{(comment_index * 100.to_f / total_comments).round(2)}%," \
      " time elapsed: #{Time.now - start_time}"
  end

  result = comment_data_extractor.extract(comment[1], comment[0])
  output_file.puts(result.to_json) unless result[:team_adjectives].empty?
end

output_file.close
