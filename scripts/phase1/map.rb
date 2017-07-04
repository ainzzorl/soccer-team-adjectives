# TODO: comment

require 'yaml'
require 'treat'
require 'set'
require 'json'
require 'csv'
include Treat::Core::DSL

Dir[File.dirname(__FILE__) + '/../../lib/soccer_team_adjectives/*.rb'].each { |file| require file }

INPUT_FILE_PATH = './input/soccer_comments_and_ids_2016_11.csv'.freeze
OUTPUT_FILE_PATH = './tmp/phase1/mapped.dat'.freeze

team_name_extractor = SoccerTeamAdjectives::TeamNameExtractor.new(YAML.load_file('./config/teams.yaml'))
comment_data_extractor = SoccerTeamAdjectives::CommentDataExtractor.new(team_name_extractor)

output_file = File.open(OUTPUT_FILE_PATH, 'w')

# TODO: comment
csv_lines = CSV.read(INPUT_FILE_PATH)
total_comments = csv_lines.size

start_time = Time.now
csv_lines.each_with_index do |comment, comment_index|
  if (comment_index % 1000).zero?
    puts "Line #{comment_index}/#{total_comments}, #{(comment_index * 100.to_f / total_comments).round(2)}%," \
      " time elapsed: #{Time.now - start_time}"
  end

  result = comment_data_extractor.extract(comment[1], comment[0])
  output_file.puts(result.to_json) unless result[:team_adjectives].empty?
end

output_file.close
