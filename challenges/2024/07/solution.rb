# frozen_string_literal: true
module Year2024
  class Day07 < Solution

    def test_equation(result, operands, operators)
      result == operators.zip(operands[1..]).reduce(operands[0]) { |acc, (op, num)|
        return false if acc > result
        case op
        when :add
          acc + num
        when :mul
          acc * num
        when :concat
          "#{acc}#{num}".to_i
        end
      }
    end

    def part_1
      data.sum { |result, operands|
        [:add, :mul].repeated_permutation(operands.size-1).any? { |operators|
          test_equation(result, operands, operators)
        } ? result : 0
      }
    end

    def part_2
      data.sum { |result, operands|
        [:add, :mul, :concat].repeated_permutation(operands.size-1).any? { |operators|
          test_equation(result, operands, operators)
        } ? result : 0
      }
    end

    private
      def process_input(line)
        result, operands = line.split(":")
        [result.to_i, operands.split(" ").map(&:to_i)]
      end

  end
end
