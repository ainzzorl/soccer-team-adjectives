require 'csv'

module SoccerAdjectives
  module Phase1
    # For each comment in the data set
    # find out what entities are mentioned in it and what adjectives are used around them.
    #
    # This is by far the slowest step in the entire process.
    # It can be parallelized if it becomes too slow.

    def self.map(args)
      input_file_path = args[:input_file_path]
      output_file_path = './output/phase1/mapped.dat'.freeze

      entity_name_extractor = EntityAdjectives::EntityNameExtractor.new(args[:entity_definitions])
      comment_data_extractor = EntityAdjectives::CommentDataExtractor.new(entity_name_extractor)

      output_file = File.open(output_file_path, 'w')

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
    end
  end
end
