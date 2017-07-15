# Sort entities by total adjective count.
# Unnecessary, but makes the output more readable: most popular entities are on top.

module SoccerAdjectives
  module Phase2
    def self.sort_entities(args)
      data = args[:data]

      data = data.sort_by do |_, adjectives|
        -adjectives
          .map { |a| a['count'] }
          .inject(0) { |sum, c| sum + c }
      end

      args[:data] = data.to_h
    end
  end
end
