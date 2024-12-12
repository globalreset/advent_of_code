# frozen_string_literal: true
module Year2024
  class Day12 < Solution
    DIR = [Vector[1, 0], Vector[0, 1], Vector[-1, 0], Vector[0, -1]]

    # returns array of Sets of Vectors, 1 set for each region
    def get_regions
      grid = data.each_with_index.with_object({}) { |(line, y), grid|
        line.chars.each_with_index { |c, x| grid[Vector[y, x]] = c }
      }
      seen = Set.new
      grid.keys.each_with_object([]) { |p, regions|
        next if(seen.include?(p))
        regions << Set.new
        queue = [p]
        while(queue.size > 0)
          curr = queue.shift
          next if(regions[-1].include?(curr))
          regions[-1] << curr
          seen << curr
          DIR.each { |d|
            queue << (curr + d) if(grid[curr + d] == grid[curr])
         }
        end
      }
    end

    def part_1
      get_regions.sum { |r|
        # area = number of points
        # perimeter = number of points on the border
        # area * perimeter
        r.size * r.sum { |p| DIR.count { |d| !r.include?(p+d) } }
      }
    end

    def part_2
      get_regions.sum { |r|
        r.size *
        r.each.with_object(Set.new) { |p, sides|
          # pick any perimeter point, find the edge that's the outside edge,
          # turn 90 degrees and walk until you hit the next edge. This makes it so
          # we are counting the outside border edge before every corner (clockwise)
          DIR.each { |d|
            next if r.include?(p + d) # not the border side
            curr = p
            walk_dir = Vector[d[1], -d[0]]  # rotate 90 degrees
            # step until you would leave region or leave border side
            while r.include?(curr + walk_dir) && !r.include?(curr + d + walk_dir)
              curr += walk_dir
            end
            sides << [curr, d] # keyed off the side we're testing, not walking
          }
        }.size
      }
    end
  end
end
