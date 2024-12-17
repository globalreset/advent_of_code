# frozen_string_literal: true
module Year2024
  class Day17 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    def part_1
      reg, program = data
      out = []
      ptr = 0
      while(ptr < program.size)
        operand = program[ptr+1]
        combo = case(operand)
        when 0..3
          combo = operand
        when 4
          combo = reg["A"]
        when 5
          combo = reg["B"]
        when 6
          combo = reg["C"]
        end
        case program[ptr]
        when 0
          reg["A"] = reg["A"]/(2**combo)
          ptr += 2
        when 1
          reg["B"] = reg["B"] ^ operand
          ptr += 2
        when 2
          reg["B"] = combo % 8
          ptr += 2
        when 3
          if(reg["A"] == 0)
            ptr += 2
          else
            ptr = operand
          end
        when 4
          reg["B"] = reg["B"] ^ reg["C"]
          ptr += 2
        when 5
          out << combo % 8
          ptr += 2
        when 6
          reg["B"] = reg["A"]/(2**combo)
          ptr += 2
        when 7
          reg["C"] = reg["A"]/(2**combo)
          ptr += 2
        end
      end
      out.map(&:to_s).join(",")
    end

    # with debug prints was able to decompile the program.
    # it's operating on the value A 3-bits at a time,
    # operations are unimportant, but the main point is
    # that it all revolves around A 3 lsb bits at a time 
    def simulate_program(a)
      out = []
      reg = {"A" => a, "B" => 0, "C" => 0}
      while reg["A"] > 0
        reg["B"] = (reg["A"] % 8) ^ 1
        reg["C"] = reg["A"] / (2**reg["B"])
        reg["A"] = reg["A"] / 8
        reg["B"] = (reg["B"] ^ 4) ^ reg["C"]
        out << reg["B"] % 8
      end
      out.reverse
    end
    
    def part_2
      reg, program = data
      # test 3-bits at a time, building a sequence of digits that match the program output
      # starting with the most significant 3-bits
      program.reverse!
      possible = [[]]  # Start with empty sequence
      
      program.each_with_index { |target, i|
        # Generate all possible combinations by adding digits 0-7 to existing sequences
        new_possible = possible.flat_map { |p| (0..7).map { p + [_1] } }
        
        # Filter sequences that match program output
        possible = new_possible.select { |seq|
          a_value = seq.inject(0) { |sum, digit| sum * 8 + digit }
          simulate_program(a_value) == program[0..i]
        }
      }
      # Convert each possibility to base-8 number and find minimum
      return possible.map { |seq| seq.inject(0) { |sum, digit| sum * 8 + digit } }.min
    end

    private
      def process_dataset(set)
        reg = {}
        program = nil
        set.each { |line|
          if(line =~ /Register (\w): (\d+)/)
            reg[$1] = $2.to_i
          elsif(line =~ /Program: (.*)/)
            program = $1.split(",").map(&:to_i)
          end
        }
        [reg, program]
      end
  end
end
