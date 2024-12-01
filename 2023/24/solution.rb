# frozen_string_literal: true
module Year2023
  class Day24 < Solution
    Hailstone = Struct.new(:px, :py, :pz, :vx, :vy, :vz)

    def parse_input(input)
      input.map do |line|
        pos, vel = line.split('@').map(&:strip)
        px, py, pz = pos.split(',').map(&:strip).map(&:to_i)
        vx, vy, vz = vel.split(',').map(&:strip).map(&:to_i)
        Hailstone.new(px, py, pz, vx, vy, vz)
      end
    end

    def intersect_2d?(h1, h2, min_pos, max_pos)
      # Convert to line equation ax + by = c
      # Where a = vy, b = -vx, c = vy*px - vx*py
      a1 = h1.vy
      b1 = -h1.vx
      c1 = h1.vy * h1.px - h1.vx * h1.py

      a2 = h2.vy
      b2 = -h2.vx
      c2 = h2.vy * h2.px - h2.vx * h2.py

      # Check if lines are parallel
      det = a1 * b2 - a2 * b1
      return false if det == 0

      # Find intersection point
      x = (c1 * b2 - c2 * b1).to_f / det
      y = (a1 * c2 - a2 * c1).to_f / det

      # Check if point is within bounds
      return false if x < min_pos || x > max_pos || y < min_pos || y > max_pos

      # Check if intersection happens in the future for both hailstones
      t1 = h1.vx != 0 ? (x - h1.px) / h1.vx : (y - h1.py) / h1.vy
      t2 = h2.vx != 0 ? (x - h2.px) / h2.vx : (y - h2.py) / h2.vy

      t1 >= 0 && t2 >= 0
    end

    def part_1
      hailstones = parse_input(data)
      min_pos = 200000000000000
      max_pos = 400000000000000
      
      count = 0
      hailstones.combination(2).each do |h1, h2|
        count += 1 if intersect_2d?(h1, h2, min_pos, max_pos)
      end
      count
    end

    def part_2
      require 'z3'

      hailstones = parse_input(data)
      solver = Z3::Solver.new

      # Create variables for rock's initial position and velocity
      rpx = Z3.Int('rpx')
      rpy = Z3.Int('rpy')
      rpz = Z3.Int('rpz')
      rvx = Z3.Int('rvx')
      rvy = Z3.Int('rvy')
      rvz = Z3.Int('rvz')

      # For each hailstone, add collision equations
      hailstones.take(3).each_with_index do |h, i|
        t = Z3.Int("t#{i}")  # Time of collision for this hailstone
        solver.assert(t >= 0)  # Time must be non-negative

        # At collision time t, positions must match in all dimensions
        solver.assert(rpx + t * rvx == h.px + t * h.vx)
        solver.assert(rpy + t * rvy == h.py + t * h.vy)
        solver.assert(rpz + t * rvz == h.pz + t * h.vz)
      end

      if solver.satisfiable?
        model = solver.model
        return model[rpx].to_i + model[rpy].to_i + model[rpz].to_i
      end
      
      nil
    end
  end
end
