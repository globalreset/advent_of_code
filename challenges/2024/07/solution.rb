# frozen_string_literal: true
module Year2024
  class Day07 < Solution

    def find_eq(result, operands, operators, acc)
      return false if acc > result
      operators.any? { |op|
        tmp = if(op == :concat)
                "#{acc}#{operands[0]}".to_i
              else
                acc.send(op, operands[0])
              end
        if(operands.size == 1)
          tmp == result
        else
          find_eq(result, operands[1..], operators, tmp)
        end
      }
    end

    def part_1
      data.sum { |result, operands|
        find_eq(result, operands[1..], [:+, :*], operands[0]) ? result : 0
      }
    end

    def part_2
      data.sum { |result, operands|
        find_eq(result, operands[1..], [:+, :*, :concat], operands[0]) ? result : 0
      }
    end

    private
      def process_input(line)
        result, operands = line.split(":")
        [result.to_i, operands.split(" ").map(&:to_i)]
      end

  end
end
