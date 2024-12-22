# frozen_string_literal: true
require 'set'

module Year2024
  class Day21 < Solution
    NUMPAD = {
      '7' => Vector[0, 0], '8' => Vector[1, 0], '9' => Vector[2, 0],
      '4' => Vector[0, 1], '5' => Vector[1, 1], '6' => Vector[2, 1],
      '1' => Vector[0, 2], '2' => Vector[1, 2], '3' => Vector[2, 2],
                           '0' => Vector[1, 3], 'A' => Vector[2, 3]
    }

    DIRPAD = {
                           '^' => Vector[1, 0], 'A' => Vector[2, 0],
      '<' => Vector[0, 1], 'v' => Vector[1, 1], '>' => Vector[2, 1]
    }

    def cache_path(pad, avoid)
      cache = {}
      pad.each { |a, a_pos|
        pad.each { |b, b_pos|
          if a == b
            (cache[a] ||= {})[b] = ['']
            next
          end
          (cache[a] ||= {})[b] = ['',''].map.with_index { |path, i|
            path = ''
            pos = a_pos.dup
            hvec = Vector[b_pos[0] > a_pos[0] ? 1 : -1, 0]
            hdir = b_pos[0] > a_pos[0] ? '>' : '<'
            vvec = Vector[0, b_pos[1] > a_pos[1] ? 1 : -1]
            vdir = b_pos[1] > a_pos[1] ? 'v' : '^'
            valid = true

            while valid && (i==0) && (pos[0] != b_pos[0])
              path += hdir
              pos += hvec
              valid = false if(pos == avoid)
            end
            while valid && (pos[1] != b_pos[1])
              path += vdir
              pos += vvec
              valid = false if(pos == avoid)
            end
            while valid && (i==1) && (pos[0] != b_pos[0])
              path += hdir
              pos += hvec
              valid = false if(pos == avoid)
            end
            path if(valid)
          }.compact.uniq
        }
      }
      cache
    end

    def find_shortest(code, depth, cache, dirpad_cache)
      return code.length + 1 if depth == 0
      return cache[depth][code] if cache[depth][code]

      full_code = "A#{code}A"
      cache[depth][code] = (0...full_code.length-1).sum { |i|
        dirpad_cache[full_code[i]][full_code[i+1]].map { |p| find_shortest(p, depth-1, cache, dirpad_cache) }.min
      }
    end

    def solve(depth)
      numpad_cache = cache_path(NUMPAD, Vector[0, 3])
      dirpad_cache = cache_path(DIRPAD, Vector[0, 0])

      cache = Hash.new { |h,k| h[k] = {} }

      data.sum { |code|
        # always start from "A"
        full_code = "A#{code}"
        (0...full_code.length-1).sum { |i|
          numpad_cache[full_code[i]][full_code[i+1]].map { |p| find_shortest(p, depth, cache, dirpad_cache) }.min
        } * code[0,3].to_i
      }
    end

    def part_1
      solve(2)
    end

    def part_2
      solve(25)
    end

  end
end
