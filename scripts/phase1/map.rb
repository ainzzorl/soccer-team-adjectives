require 'yaml'
require 'treat'
require 'set'
require 'json'
require 'csv'
include Treat::Core::DSL

Dir[File.dirname(__FILE__) + '/../../lib/soccer_team_adjectives/*.rb'].each { |file| require file }

INPUT_FILE = './input/soccer-comments.csv'.freeze
OUTPUT_FILE = './tmp/phase1/mapped.dat'.freeze

config = YAML.load_file './config/config.yaml'

teams = YAML.load_file './config/teams.yaml'

team_name_extractor = SoccerTeamAdjectives::TeamNameExtractor.new(teams, config['common_word_team_names'])

output_file = File.open(OUTPUT_FILE, 'w')

csv_lines = CSV.read(INPUT_FILE)
number_of_lines = csv_lines.size
line_index = 0

start_time = Time.now
csv_lines.each do |comment|
  if (line_index % 1000).zero?
    puts "Line #{line_index}/#{number_of_lines}, #{(line_index * 100.to_f / number_of_lines).round(2)}%," \
      " time elapsed: #{Time.now - start_time}"
  end
  line_index += 1

  team_adjective_counts = {}
  par = paragraph comment[0]
  par.segment.each do |segment|
    teams = team_name_extractor.extract(segment)
    next if teams.empty?
    segment.apply :category
    adjectives = segment
                 .adjectives
                 .map { |a| a.to_s.downcase }
    next if adjectives.empty?

    teams.each do |team|
      team_adjective_counts[team] = {} unless team_adjective_counts.key?(team)
      team_counts = team_adjective_counts[team]
      adjectives.each do |adjective|
        count = team_counts[adjective]
        team_counts[adjective] = count.nil? ? 1 : count + 1
      end
    end
  end
  next if team_adjective_counts.empty?
  result = {
    comment_id: comment[1],
    team_adjectives: team_adjective_counts
  }
  output_line = result.to_json
  output_file.puts(output_line)
end

output_file.close
