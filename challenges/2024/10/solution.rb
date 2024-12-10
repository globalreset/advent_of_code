# frozen_string_literal: true
module Year2024
  class Day10 < Solution
    def dfs(pos, visited, unique = true)
      return 0 if(unique && visited.include?(pos))
      visited << pos
      curr = data[pos]
      return 1 if curr == 9
      [Vector[-1,0], Vector[1,0], Vector[0,-1], Vector[0,1]].sum { |d|
        next 0 if(data[pos+d] != curr + 1)
        dfs(pos+d, visited, unique)
      }
    end

    def part_1
      data.select { |k, v| v==0 }.keys.sum { |k| dfs(k, Set.new, true) }
    end

    def part_2
      data.select { |k, v| v==0 }.keys.sum { |k| dfs(k, Set.new, false) }
    end

    private
      def process_dataset(set)
        set.each_with_index.with_object({}) { |(line, y), grid|
          line.chars.each_with_index { |c, x|
            grid[Vector[y, x]] = c.to_i
          }
        }
      end
  end
end
