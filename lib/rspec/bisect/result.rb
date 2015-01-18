module RSpec
  module Bisect
    class Result < Struct.new(:result_string)
      def as_json
        JSON.parse result_string
      end
    end
  end
end
