# frozen_string_literal: true
module Year2024
  class Day14 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    MAX_X = 101
    MAX_Y = 103

    def part_1
      robots = data.map { |px, py, vx, vy|
        px = (px + 100*vx) % MAX_X
        py = (py + 100*vy) % MAX_Y
        [px, py]
      }
      [ 
        [(0..((MAX_X-2)/2)), (0..((MAX_Y-2)/2))],
        [(((MAX_X+1)/2)...MAX_X), (0..((MAX_Y-2)/2))],
        [(0..((MAX_X-2)/2)), (((MAX_Y+1)/2)...MAX_Y)],
        [(((MAX_X+1)/2)...MAX_X), (((MAX_Y+1)/2)...MAX_Y)]
      ].map { |quad|
        cnt = robots.count { |px,py|
         (quad[0].include?(px) && quad[1].include?(py))
        }
        cnt == 0 ? nil : cnt
      }.compact.reduce(&:*)
    end

    def part_2
      # first attempt was (MAX_X*MAX_Y) loops and save off the result
      # with the lowest safety factor. But when the robots are making
      # a picture, it's reasonable to assume they are all contributing,
      # so not stacked up anywhere. So instead find the first instance
      # where this is true.
      robots = nil
      step = (1..).find { |i|
        robots = data.map { |px, py, vx, vy|
          px = (px + i*vx) % MAX_X
          py = (py + i*vy) % MAX_Y
          [px, py]
        }.to_set
        (robots.size == data.size) # all robots are visible (non-stacked)
      }
      (0...MAX_Y).each { |y|
        (0...MAX_X).each { |x|
          print robots.include?([x, y]) && "R" || "."
        }
        puts
      }
      step
    end

    private
      def process_input(line)
        line.scan(/-?\d+/).map(&:to_i)
      end
  end
end
