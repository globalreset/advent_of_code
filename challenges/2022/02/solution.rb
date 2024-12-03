# frozen_string_literal: true
module Year2022
  class Day02 < Solution
    WINS = { :rock => :scissors, :scissors => :paper, :paper => :rock }
    LOSES = WINS.invert
    SCORE = { :rock => 1, :paper => 2, :scissors => 3}
    
    def part_1
      dec = { 
         "A" => :rock, "B" => :paper, "C" => :scissors,
         "X" => :rock, "Y" => :paper, "Z" => :scissors
      }
      data.map { |a,b| 
        p1, p2 = dec[a], dec[b]
        SCORE[p2] + (p1==WINS[p2] ? 6 : p1==p2 ? 3 : 0)
      }.sum
    end

    def part_2
      dec = { 
         "A" => :rock, "B" => :paper, "C" => :scissors,
         "X" => :lose, "Y" => :draw, "Z" => :win
      }
      data.map { |a,b| 
        p1 = dec[a]
        p2 = case(dec[b])
             when :lose
                WINS[p1]  # What p1 beats
             when :draw
                p1
             when :win
                LOSES[p1]  # What beats p1
             end
        SCORE[p2] + (p1==WINS[p2] ? 6 : p1==p2 ? 3 : 0)
      }.sum
    end

    private
      def process_input(line)
        line.split(" ")
      end
  end
end
