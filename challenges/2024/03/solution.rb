# frozen_string_literal: true
module Year2024
  class Day03 < Solution

    def part_1
      data.map { |line|
        line.scan(/mul\(\d+,\d+\)/).map{ |m|
          m.scan(/\d+/).map(&:to_i).reduce(&:*)
        }.sum
      }.sum
    end

    def part_2
      enabled = true
      data.map { |line|
        line.scan(/mul\(\d+,\d+\)|do\(\)|don't\(\)/).map { |m|
          result = 0;
          case(m)
          when /mul\(\d+,\d+\)/
            result =  m.scan(/\d+/).map(&:to_i).reduce(&:*) if(enabled)
          when /do\(\)/
            enabled = true
          when /don't\(\)/
            enabled = false
          end
          result
        }.sum
      }.sum
    end

  end
end
