# frozen_string_literal: true
module Year2024
  class Day08 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    def part_1
      grid, antenna = data
      antinodes = Set.new
      antenna.values.each { |coords|
        coords.combination(2).each { |a1, a2|
          dy = (a2[0] - a1[0])
          dx = (a2[1] - a1[1])

          anti1 = [a1[0] - dy, a1[1] - dx]
          anti2 = [a2[0] + dy, a2[1] + dx]

          antinodes << anti1 if(grid[anti1]!=nil)
          antinodes << anti2 if(grid[anti2]!=nil)

          (grid[anti1]!=nil ? 1 : 0) + (grid[anti2]!=nil ? 1 : 0)
        }
      }
      antinodes.size
    end

    def part_2
      grid, antenna = data
      antinodes = Set.new
      antenna.each { |ant,coords|
        coords.combination(2).each { |a1, a2|
          dy = (a2[0] - a1[0])
          dx = (a2[1] - a1[1])

          [1,-1].each { |dir|
            step = 0
            loop do
              anti1 = [a1[0] + dir*step*dy, a1[1] + dir*step*dx]
              break if(grid[anti1]==nil)
              antinodes << anti1
              step += 1
            end 
          }
        }
      }
      antinodes.size
    end

    private
      def process_dataset(set)
        grid = {}
        antenna = {}
        set.each_with_index { |row, y|
          row.chars.each_with_index { |col, x|
            if(col != ".")
              (antenna[col] ||= []) << [y, x]
            end
            grid[[y, x]] = col
          }
        }
        [grid, antenna]
      end
  end
end
