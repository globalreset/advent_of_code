# frozen_string_literal: true
module Year2024
  class Day20 < Solution
    def find_path(maxCheat = 2)
      start = data.select { |k, v| v == 'S' }.keys.first
      goal = data.select { |k, v| v == 'E' }.keys.first
      walls = data.select { |k, v| v == '#' }.keys.to_set
      
      # Find distance from start for every position
      stepCnt = { start => 0 }

      queue = [start]
      until queue.empty?
        pos = queue.shift
        steps = stepCnt[pos]
        
        [Vector[-1,0], Vector[1,0], Vector[0,-1], Vector[0,1]].each do |d|
          newPos = pos + d
          next if (walls.include?(newPos) || stepCnt.key?(newPos))
          stepCnt[newPos] = steps + 1
          queue << newPos
        end
      end
     
      # visit all positions on the base path
      stepCnt.to_a.sum do |pos, steps|
        # check every x and y adjustment possible for cheat
        (-maxCheat..maxCheat).sum do |dx|
          (-maxCheat..maxCheat).count do |dy|
            newPos = pos + Vector[dx, dy]
            next if (dx==0 && dy==0) 
            next if (dx.abs + dy.abs > maxCheat)
            next unless stepCnt.key?(newPos)
            
            # See if cheating to that position is better by at least 100
            stepCnt[newPos] - (steps + (dx.abs + dy.abs)) >= 100
          end
        end
      end
    end
    
    def part_1
      find_path(2)
    end
    
    def part_2
      find_path(20)
    end

    private
      def process_dataset(set)
        set.each_with_index.with_object({}) { |(line, y), grid|
          line.chars.each_with_index { |c, x|
            grid[Vector[x, y]] = c
          }
        }
      end
  end
end
