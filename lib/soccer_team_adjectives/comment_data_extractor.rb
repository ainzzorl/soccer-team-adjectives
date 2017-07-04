require 'treat'
include Treat::Core::DSL

module SoccerTeamAdjectives
  # Extaracts team names and adjectives from comments.
  class CommentDataExtractor
    def initialize(team_name_extractor)
      @team_name_extractor = team_name_extractor
    end

    def extract(comment_id, comment_body)
      team_adjective_counts = {}
      paragraph(comment_body).segment.each do |segment|
        teams = @team_name_extractor.extract(segment)
        next if teams.empty?
        segment.apply :category
        adjectives = segment.adjectives.map { |a| a.to_s.downcase }
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
      {
        comment_id: comment_id,
        team_adjectives: team_adjective_counts
      }
    end
  end
end
