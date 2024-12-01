# frozen_string_literal: true
module Year2024
  class Day01 < Solution
    def part_1
      data.transpose.map(&:sort).transpose.map{|x,y| (x-y).abs }.sum
    end

    def part_2
      lists = data.transpose.map(&:sort)
      lists[0].map {|x| lists[1].count(x) * x }.sum
    end

    private
      def process_input(line)
        line.chomp.scan(/\d+/).map(&:to_i)
      end
  end
end
