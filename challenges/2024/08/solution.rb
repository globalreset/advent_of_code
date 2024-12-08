# frozen_string_literal: true
module Year2024
  class Day08 < Solution
    def in_bounds?(max, pos)
      pos.real >= 0 && pos.real < max.real && pos.imag >= 0 && pos.imag < max.imag
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
          (0..).each { |step|
            anti = a + step*(b - a)
            break unless in_bounds?(max, anti)
            antinodes << anti
          }
        }
      }.size
    end

    private
      # return max pos in form of complex number
      # and a hash array where key is antenna char
      # and value is array of coords (as complex numbers)
      def process_dataset(set)
        [ (set.size + set[0].size*1i), 
          set.each_with_index.with_object({}) { |(row, y), hash|
            row.chars.each_with_index { |col, x| 
              (hash[col] ||= []) << y + x*1i if(col != ".") 
            }
          }.values ]
      end
  end
end
