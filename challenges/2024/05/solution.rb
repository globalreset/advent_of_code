# frozen_string_literal: true
module Year2024
  class Day05 < Solution

    def part_1
      data["print"].map { |print|
        pass = print.each_with_index.all? { |n, i|
          (data["rules"][n]||[]).map { |r|
            print.find_index(r)
          }.compact.all? { |ri| ri > i }
        }
        next if (!pass)
        print[print.size/2]
      }.compact.sum
    end

    def part_2
      data["print"].map { |print|
        pass = print.each_with_index.all? { |n, i|
          (data["rules"][n]||[]).map { |r|
            print.find_index(r)
          }.compact.all? { |ri| ri > i }
        }
        next if (pass)
        newPrint = []
        print.each { |n|
          newIdx = (data["rules"][n]||[]).map{ |a| 
            newPrint.find_index(a) 
          }.compact.min || newPrint.size
          newPrint.insert(newIdx, n)
        }
        newPrint[newPrint.size/2]
        # solution I got inspired to try after I was done, leaving here to remind me
        #print.sort { |a,b|
        #  (data["rules"][a]||[]).include?(b) ? -1 : (data["rules"][b]||[]).include?(a) ? 1 : 0
        #}[print.size/2]
      }.compact.sum
    end

    private
      def process_dataset(set)
        tmpRules, tmpPrint = set.slice_when{ |l| l.size==0 }.map(&:compact)
        set = {"rules" => {}, "print" => []}
        tmpRules.map{ |l| l.split("|").map(&:to_i) }.each { |a,b| 
          (set["rules"][a] ||= []) << b
        }
        set["print"] = tmpPrint.map{ |l| l.split(",").map(&:to_i) }
        set
      end
  end
end
