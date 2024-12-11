# frozen_string_literal: true
module Year2024
  class Day11 < Solution
    def part_1
      stones = data.split(" ").map(&:to_i)
      25.times {
        stones = stones.map { |s|
          if(s==0)
            1
          elsif(s.to_s.size.even?)
            c = s.to_s.chars
            [c[0...c.size/2].join.to_i, c[c.size/2..-1].join.to_i]
          else
            s * 2024
          end
        }.flatten
      }
      stones.size
    end

    # classic "maintain a count of instances" instead of
    # maintain a list of instances (too slow, unwieldy)
    def part_2
      stones = data.split(" ").map(&:to_i)
      counters = stones.zip(Array.new(stones.size, 1)).to_h
      75.times {
        counters = counters.each.with_object((Hash.new(0))) { |(stone, cnt), updated|
          s = stone.to_s.chars
          if(stone==0)
            updated[1] += cnt
          elsif(s.size.even?)
            updated[s[0...s.size/2].join.to_i] += cnt
            updated[s[s.size/2..-1].join.to_i] += cnt
          else
            updated[stone * 2024] += cnt
          end
        }
      }
      counters.values.sum
    end
  end
end
