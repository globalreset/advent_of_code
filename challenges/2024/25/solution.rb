# frozen_string_literal: true
module Year2024
  class Day25 < Solution
    def part_1
      schematics = data.slice_when { |l| l.empty? }.map { |group| group.reject(&:empty?) }.to_a
      locks = []
      keys = []
      schematics.each { |schematic|
        t = schematic.map(&:chars).transpose.map { |r|
          if(r[0] == '.')
            6 - r.index('#')
          else
            r.index('.') - 1
          end
        }
        locks << t && next if(schematic[0].chars.all? { |c| c == '#' })
        keys << t && next if(schematic[-1].chars.all? { |c| c == '#' })
      }

      locks.sum { |l|
        keys.count { |k|
           l.zip(k).all? { |a, b| a + b <= 5 }
        }
      }
    end

    def part_2
      nil
    end

  end
end
