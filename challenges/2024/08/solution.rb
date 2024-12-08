# frozen_string_literal: true
module Year2024
  class Day08 < Solution
    def in_bounds?(max, pos)
      pos[0].between?(0, max[0]) && pos[1].between?(0, max[1])
    end

    def part_1
      max, antenna = data
      antenna.each.with_object(Set.new) { |coords, antinodes|
        # permutation does both directions, so get one vector (b-a)
        # and find the next node along that vector. We'll get opposite
        # vector on another permutation
        coords.permutation(2).each { |a, b|
          c = a - (b - a)
          antinodes << c if(in_bounds?(max, c))
        }
      }.size
    end

    def part_2
      max, antenna = data
      antenna.each.with_object(Set.new) { |coords, antinodes|
        coords.permutation(2).each { |a, b|
          (0..).each { |step| # start at 0 to get initial antenna
            c = a - step*(b - a)
            break unless in_bounds?(max, c)
            antinodes << c
          }
        }
      }.size
    end

    private
      # return max pos in form of complex number
      # and a hash array where key is antenna char
      # and value is array of coords (as complex numbers)
      def process_dataset(set)
        [ Vector[set.size-1, set[0].size-1], 
          set.each_with_index.with_object({}) { |(row, y), hash|
            row.chars.each_with_index { |col, x| 
              (hash[col] ||= []) << Vector[y, x] if(col != ".") 
            }
          }.values ]
      end
  end
end
