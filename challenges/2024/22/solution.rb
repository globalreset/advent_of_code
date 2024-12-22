# frozen_string_literal: true
module Year2024
  class Day22 < Solution
    def recipe(x)
      x = ((x*64) ^ x) % 16777216
      x = ((x/32) ^ x) % 16777216
      x = ((x*2048) ^ x) % 16777216
    end

    def part_1
      data.map(&:to_i).sum { |sn|
        2000.times { sn = recipe(sn) }
        sn
      }
    end

    def part_2
      data.map(&:to_i).each.with_object({}) { |sn, scores|
        prices = 2000.times.with_object([sn]) { |_, arr| arr << recipe(arr[-1]) }.map { _1 % 10 }
        changes = prices.each_cons(2).to_a.map { |a, b| b - a }

        # get every pattern of changes (each_cons(4)) and create a hash with the pattern
        # and price at end of pattern for the first occurrence only
        pattern_price = {}
        changes.each_cons(4).with_index { |pattern, i|
          pattern_price[pattern] = prices[i+4] unless pattern_price.key?(pattern)
        }

        # collect pattern into global score hash accumulating price per pattern for each sn
        pattern_price.each { |pattern, score| scores[pattern] = (scores[pattern] || 0) + score }
      }.values.max
    end
  end
end
