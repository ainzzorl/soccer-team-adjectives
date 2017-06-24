#!/usr/bin/env ruby

require 'yaml'
require 'treat'
require 'set'
require 'json'
require 'csv'
include Treat::Core::DSL

teams = YAML.load_file './config/teams.yaml'

output_file = File.open('./tmp/mapped.dat', 'w')

team_name_map = {}
teams.each do |team|
  team_name_map[team['canonical_name'].downcase] = team['canonical_name']
  team['alternative_names'].each do |alt|
    team_name_map[alt.downcase] = team['canonical_name']
  end
end

number_of_lines = File.open('./input/soccer-comments.csv').readlines.size
line_index = 0

def teams_in_segment(segment, team_name_map)
  teams = Set.new
  word_index = 0
  last_two_words = []
  last_three_words = []
  segment.each_word do |w|
    word = w.to_s.downcase
    last_two_words.shift if word_index > 1
    last_three_words.shift if word_index > 2
    last_two_words << w
    last_three_words << w
    if team_name_map.key?(word)
      teams.add(team_name_map[word])
    elsif word_index > 0 && team_name_map.key?(last_two_words.join(' '))
      teams.add(team_name_map[last_two_words.join(' ')])
    elsif word_index > 1 && team_name_map.key?(last_three_words.join(' '))
      teams.add(team_name_map[last_three_words.join(' ')])
    end
    word_index += 1
  end
  teams
end

start_time = Time.now
CSV.foreach("input/soccer-comments-and-ids-2017-05.csv") do |comment|
  if line_index % 1000 == 0
    puts "Line #{line_index}/#{number_of_lines}, #{(line_index * 100.to_f / number_of_lines).round(2)}%, time elapsed: #{Time.now - start_time}"
  end
  line_index += 1

  team_adjective_counts = {}
  par = paragraph comment[0]
  par.segment.each do |segment|
    segment.tokenize
    teams = teams_in_segment(segment, team_name_map)
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
        count.nil? ? team_counts[adjective] = 1 : team_counts[adjective] = count + 1
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
