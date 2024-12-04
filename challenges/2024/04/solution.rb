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
      count = 0
      data.size.times { |x|
        data[0].size.times { |y|
          [[1, 0], [-1, 0], [0, 1], [0, -1], 
           [1, 1], [1, -1], [-1, 1], [-1, -1]].each { |dx, dy|
            count += 1 if check(x, y, dx, dy, "XMAS".chars)
          }
        }
      }
      count
    end

    def part_2
      count = 0
      (1..(data.size-2)).each { |x|
        (1..(data[0].size-2)).each { |y|
          if(data[x][y]=="A")
            diags = [
              data[x-1][y+1], data[x+1][y+1],
              data[x+1][y-1], data[x-1][y-1]
            ]
            count += 1 if(diags==["M", "M", "S", "S"] ||
                          diags==["S", "M", "M", "S"] ||
                          diags==["S", "S", "M", "M"] ||
                          diags==["M", "S", "S", "M"])
          end
        }
      }
      count
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
