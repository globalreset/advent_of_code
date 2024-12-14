# frozen_string_literal: true
module Year2024
  class Day14 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    MAX_X = 101
    MAX_Y = 103
    Q = [ 
      [(0..((MAX_X-2)/2)), (0..((MAX_Y-2)/2))],
      [(((MAX_X+1)/2)...MAX_X), (0..((MAX_Y-2)/2))],
      [(0..((MAX_X-2)/2)), (((MAX_Y+1)/2)...MAX_Y)],
      [(((MAX_X+1)/2)...MAX_X), (((MAX_Y+1)/2)...MAX_Y)]
      ]

    def part_1
      robots = data.map(&:dup)
      safety_factor = nil
      100.times { |i|
        quads = [0,0,0,0]
        robots = robots.map { |robot|
          robot[0] += robot[1]
          robot[0][0] = robot[0][0] % MAX_X
          robot[0][1] = robot[0][1] % MAX_Y
          Q.each.with_index { |quad, i|
            if(quad[0].include?(robot[0][0]) && quad[1].include?(robot[0][1]))
              quads[i] += 1
            end
          }
          robot
        }
        safety_factor = quads.map { |q| q == 0 ? nil : q }.compact.reduce(&:*)
      }
      safety_factor
    end

    def part_2
      robots = data
      safety_factor = nil
      step = 0
      saved_grid = nil
      (MAX_X*MAX_Y).times{ |i|
        grid = {}
        quads = [0,0,0,0]
        robots = robots.map { |robot|
          robot[0] += robot[1]
          robot[0][0] = robot[0][0] % MAX_X
          robot[0][1] = robot[0][1] % MAX_Y
          grid[robot[0]] = "R"
          Q.each.with_index { |quad, i|
            if(quad[0].include?(robot[0][0]) && quad[1].include?(robot[0][1]))
              quads[i] += 1
            end
          }
          robot
        }
        sf = quads.map { |q| q == 0 ? nil : q }.compact.reduce(&:*)
        if(safety_factor.nil? || sf < safety_factor)
          safety_factor = sf
          step = i + 1
          safety_factor = sf
          saved_grid = grid
        end
      }

      #(0...MAX_Y).each { |y|
      #  (0...MAX_X).each { |x|
      #    print saved_grid[Vector[x, y]] || "."
      #  }
      #  puts
      #}
      step
    end

    private
      # Processes each line of the input file and stores the result in the dataset
      def process_input(line)
        line.split(" ").map{ |l| l.scan(/-?\d+/) }.map{ |x,y| Vector[x.to_i,y.to_i] }
      end
  end
end
