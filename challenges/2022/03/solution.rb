# frozen_string_literal: true
module Year2022
  class Day03 < Solution
    PRI = (('A'..'Z').to_a.zip((27..52).to_a) + ('a'..'z').to_a.zip((1..26).to_a)).to_h

    def part_1
      data.map { |r|
        r.chars.each_slice(r.size/2).to_a.map(&:to_set).reduce(:&).map{ |c| PRI[c] }.sum
      }.sum
    end

    def part_2
      data.each_slice(3).map { |rs|
        rs.map(&:chars).map(&:to_set).reduce(:&).map{ |c| PRI[c] }.sum
      }.sum
    end

  end
end
