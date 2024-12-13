# frozen_string_literal: true
module Year2024
  class Day13 < Solution

    def get_claw_machines
      data.slice_when { _1.size==0 }.to_a.map{ |group|
        group.map{ |l| 
          if(l =~ /Button ([AB]): X\+(\d+), Y\+(\d+)/)
            [$1.to_sym, [$2.to_i, $3.to_i]]
          elsif(l =~ /Prize: X=(\d+), Y=(\d+)/)
            [:prize, [$1.to_i, $2.to_i]]
          end
        }.compact.to_h
      }
    end

    # solved with z3 in the moment, but went back and
    # educated myself about Cramer's rule afterwards
    def solve(ax, ay, bx, by, px, py)
      # Cramer's rule
      # d = |ax bx| , a = |px bx| / d , b = |ax py| / d
      #     |ay by|       |py bx|           |ay py|
      d = ax * by - bx * ay # determinant
      return nil if(d == 0) # skip parallel lines

      a = (px * by - py * bx) / (d*1.0)
      b = (py * ax - px * ay) / (d*1.0)
      return nil unless a == a.floor && b == b.floor # skip non-integer solution

      return nil if a < 0 || b < 0 # skip negative solution

      [a.floor, b.floor]
    end

    def solve_z3(ax, ay, bx, by, px, py)
      require 'z3'
      solver = Z3::Solver.new
      a = Z3.Int('a')
      b = Z3.Int('b')

      solver.assert(a >= 0)
      solver.assert(b >= 0)
      solver.assert(ax * a + bx * b == px)
      solver.assert(ay * a + by * b == py)

      return nil unless solver.satisfiable?

      [solver.model[a].to_i, solver.model[b].to_i]
    end

    def part_1
      get_claw_machines.map { |g|
        s = solve(*g[:A], *g[:B], *g[:prize])
        #s = solve_z3(*g[:A], *g[:B], *g[:prize])
        3*s[0] + s[1] if(s!=nil)
      }.compact.sum
    end

    def part_2
      get_claw_machines.map { |g|
        g[:prize][0] += 10000000000000
        g[:prize][1] += 10000000000000

        s = solve(*g[:A], *g[:B], *g[:prize])
        #s = solve_z3(*g[:A], *g[:B], *g[:prize])
        3*s[0] + s[1] if(s!=nil)
      }.compact.sum
    end


  end
end
