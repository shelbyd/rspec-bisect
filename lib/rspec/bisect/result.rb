module RSpec
  module Bisect
    class Result < Struct.new(:result_string)
      class ParserError < StandardError; end

      def as_json
        parsed_lines = result_string.split("\n").lazy.map do |line|
          begin
            JSON.parse line
          rescue JSON::ParserError
            #ignored
          end
        end
        parsed_result = parsed_lines.reject { |result| result.nil? }.first
        parsed_result || raise(ParserError.new('Could not parse json'))
      end
    end
  end
end
