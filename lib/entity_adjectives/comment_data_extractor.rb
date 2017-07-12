require 'treat'
include Treat::Core::DSL

module EntityAdjectives
  # Extaracts entity names and adjectives from comments.
  class CommentDataExtractor
    def initialize(entity_name_extractor)
      @entity_name_extractor = entity_name_extractor
    end

    def extract(comment_id, comment_body)
      entity_adjective_counts = {}
      paragraph(comment_body).segment.each do |segment|
        entities = @entity_name_extractor.extract(segment)
        next if entities.empty?
        adjectives = extract_adjectives(segment)
        next if adjectives.empty?

        add_adjectives_to_entities(entity_adjective_counts, entities, adjectives)
      end
      {
        comment_id: comment_id,
        entity_adjectives: entity_adjective_counts
      }
    end

    private

    def add_adjectives_to_entities(entity_adjective_counts, entities, adjectives)
      entities.each do |entity|
        entity_adjective_counts[entity] = {} unless entity_adjective_counts.key?(entity)
        entity_counts = entity_adjective_counts[entity]
        adjectives.each do |adjective|
          count = entity_counts[adjective]
          entity_counts[adjective] = count.nil? ? 1 : count + 1
        end
      end
    end

    def extract_adjectives(segment)
      segment.apply :category
      segment.adjectives.map { |a| a.to_s.downcase }
    end
  end
end
