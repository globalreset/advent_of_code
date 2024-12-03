# frozen_string_literal: true
module Year2022
  class Day01 < Solution
    def part_1
      data[-1]
    end

    def part_2
      data[-3..-1].sum
    end

    private
      def process_dataset(set)
        set.slice_when { |_e, n| n.empty? }
           .map { |group| group.reject(&:empty?).map(&:to_i).sum }
           .sort
      end
  end
end
