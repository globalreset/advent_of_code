# frozen_string_literal: true
module Year2024
  class Day16 < Solution
    DIR = [ Vector[0, 1], Vector[1, 0], Vector[0, -1], Vector[-1, 0] ]

    def find_path(grid, start, dir, goal)
      path = {}
      scores = {}
      scores.default = Float::INFINITY
      scores[ [start, dir] ] = 0

      pqueue = PQueue.new([[0, start, dir]]) { |a, b| b[0] <=> a[0] }

      until pqueue.empty?
        # current score, position, direction
        cs, cp, cd = pqueue.pop
        if cp == goal
          return cs, cd, path
        end

        #graph.neighbors(current).each do |vertex|
        [ [cs + 1, cp + DIR[cd], cd],
          [cs + 1000, cp, (cd-1)%4],
          [cs + 1000, cp, (cd+1)%4] ].each { |ncost, np, nd|
          next if grid[np] == '#'
          if(ncost < scores[[np, nd]])
            pqueue.push [ncost, np, nd]
            path[[np, nd]] = [[cp, cd]]
            scores[[np, nd]] = ncost
          elsif(ncost == scores[[np, nd]])
            path[[np, nd]] << [cp, cd]
          end
        }
      end

    end

    def part_1
      grid = data
      start = grid.select { |k, v| v == 'S' }.keys.first
      goal = grid.select { |k, v| v == 'E' }.keys.first

      score, dir, path = find_path(data, start, 0, goal)
      score
    end

    def part_2
      grid = data
      start = grid.select { |k, v| v == 'S' }.keys.first
      goal = grid.select { |k, v| v == 'E' }.keys.first

      score, dir, path = find_path(data, start, 0, goal)
      visited = Set.new
      q = path[[goal, dir]]
      p q.inspect
      until q.empty?
        k = q.shift
        visited << k.first
        q += path[k] unless path[k].nil?
      end
      visited.size + 1
    end

    private
      def process_dataset(set)
        set.each_with_index.with_object({}) { |(line, y), grid|
          line.chars.each_with_index { |c, x|
            grid[Vector[y, x]] = c
          }
        }
      end
  end
end
