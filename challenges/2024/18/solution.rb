# frozen_string_literal: true
module Year2024
  class Day18 < Solution
    def find_path(corrupted)
      start = Vector[0, 0]
      goal = Vector[70,70]

      pqueue = PQueue.new([[0,start]]) { |a, b| a[0] <=> b[0] }
      visited = Set.new
      until pqueue.empty?
        step, pos = pqueue.shift
        next if visited.include?(pos) || corrupted.include?(pos)
        visited << pos
        if pos == goal
          return step
        else
          [Vector[-1,0], Vector[1,0], Vector[0,-1], Vector[0,1]].each { |d|
            newPos = pos + d
            next unless (newPos[0] >= start[0] && newPos[0] <= goal[0] && newPos[1] >= start[1] && newPos[1] <= goal[1])
            next if(corrupted.include?(newPos) || visited.include?(newPos))
            pqueue << [step + 1, newPos]
          }
        end
      end
      return nil
    end

    def part_1
      find_path(data[0...1024].to_set)
    end

    def part_2
      byteCnt = (1024...data.size).bsearch { |i| find_path(data[0..i].to_set) == nil }
      "#{data[byteCnt][0]},#{data[byteCnt][1]}"
    end

    private
      def process_input(line)
        Vector[*line.scan(/-?\d+/).map(&:to_i)]
      end
  end
end
