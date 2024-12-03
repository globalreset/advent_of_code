# frozen_string_literal: true
module Year2022
  class Day04 < Solution
    def part_1
      data.map { |p|
        p1,p2 = p.scan(/\d+-\d+/).map { |r| Range.new(*r.split("-").map(&:to_i)) }
        p1.cover?(p2) || p2.cover?(p1)
      }.count(true)
    end

    def part_2
      data.map { |p|
        p1,p2 = p.scan(/\d+-\d+/).map { |r| Range.new(*r.split("-").map(&:to_i)) }
        p1.overlap?(p2)
      }.count(true)
    end
  end
end
