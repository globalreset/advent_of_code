# frozen_string_literal: true
module Year2024
  class Day02 < Solution

    def check_report(report)
      diffs = report.each_cons(2).map{ |a, b| b - a }
      diffs.all? { |v| v!=0 && v.abs <= 3 && v.positive? == diffs.first.positive? }
    end

    def part_1
      data.map{ |report| check_report(report) }.count(true)
    end

    def part_2
      data.map{ |report|
        check_report(report) || 
          (0...report.size).any?{ |i| 
            check_report(report.first(i) + report.drop(i+1)) 
          } 
      }.count(true)
    end

    private
      def process_input(line)
        line.split(" ").map(&:to_i)
      end
  end
end
