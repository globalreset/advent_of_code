# frozen_string_literal: true
module Year2024
  class Day06 < Solution
    
    DIR = { ">" => [0,1], "<" => [0,-1], "v" => [1,0], "^" => [-1,0] }
    TURN = { ">" => "v", "<" => "^", "v" => "<", "^" => ">" }

    # returns false if loop detected
    def follow_path(grid, pos, obstructedPos = nil)
      visited = Set.new
      char = grid[pos]

      while grid[pos]!=nil 
        return false if visited.include?([pos, char])
        visited << [pos, char]
        
        nextPos = DIR[char].zip(pos).map(&:sum)
        while(grid[nextPos]=="#" || nextPos == obstructedPos)
          char = TURN[char]
          nextPos = DIR[char].zip(pos).map(&:sum)
        end

        pos = nextPos
      end
      visited.map(&:first).uniq
    end

    def part_1
      startPos, startChar = data.select { |k, v| DIR.keys.include?(v) }.first
      follow_path(data, startPos).size
    end

    def part_2
      startPos, startChar = data.select { |k, v| DIR.keys.include?(v) }.first
      # First do the original path to get all visited spots and only test those
      follow_path(data, startPos.dup).count { |testPos|
        next false if testPos == startPos
        follow_path(data, startPos, testPos) == false
      }
    end

    private
      def process_dataset(set)
        grid = {}
        set.each_with_index { |line, y|
          line.chars.each_with_index { |c, x|
            grid[[y, x]] = c
          }
        }
        grid
      end
  end
end
