# frozen_string_literal: true
module Year2024
  class Day04 < Solution

    def check(x, y, dx, dy, curr)
      return false if(x<0 || y<0 || 
                      x>=data.size || y>=data[0].size || 
                      curr.first != data[x][y])
      
      return curr.size == 1 || check(x+dx, y+dy, dx, dy, curr.drop(1))
    end

    def part_1
      (0...data.size).sum { |x|
        (0...data[0].size).sum { |y|
          [[1, 0], [-1, 0], [0, 1], [0, -1], 
           [1, 1], [1, -1], [-1, 1], [-1, -1]].count { |dx, dy|
            check(x, y, dx, dy, "XMAS".chars)
          }
        }
      }
    end

    def part_2
      crosses = [["M", "M", "S", "S"], ["S", "M", "M", "S"],
                 ["S", "S", "M", "M"], ["M", "S", "S", "M"]]
      (1..(data.size-2)).sum { |x|
        (1..(data[0].size-2)).count { |y|
          diags = [
            data[x-1][y+1], data[x+1][y+1],
            data[x+1][y-1], data[x-1][y-1]
          ]
          data[x][y]=="A" && crosses.include?(diags)
        }
      }
    end

    private
      def process_dataset(set)
        grid = []
        set.each_with_index { |line, y|
          grid[y] = []
          line.chars.each_with_index { |col, x| grid[y][x] = col } 
        }
        grid.transpose # sane x,y grid
      end
  end
end
