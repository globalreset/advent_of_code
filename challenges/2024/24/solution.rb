# frozen_string_literal: true
module Year2024
  class Day24 < Solution

    def get_value(latches, comb, name)
      return latches[name] if(latches[name])
      case(comb[name][1])
      when "AND"
        get_value(latches, comb, comb[name][0]) & get_value(latches, comb, comb[name][2])
      when "OR"
        get_value(latches, comb, comb[name][0]) | get_value(latches, comb, comb[name][2])
      when "XOR"
        get_value(latches, comb, comb[name][0]) ^ get_value(latches, comb, comb[name][2])
      end
    end

    def test_add(latches, comb, x_value, y_value)
      45.times { |i|
        latches["x%02d" % i] = (x_value >> i) & 1
        latches["y%02d" % i] = (y_value >> i) & 1
      }
      (0..45).map { |i| get_value(latches, comb, "z%02d" % i) }.reverse.join.to_i(2) == (x_value + y_value)
    end

    def print_gates(comb, name, depth=0, max_depth=3)
      return if(depth > max_depth)
      return if(name.start_with?("x") || name.start_with?("y"))
      puts "  " * depth + "#{name}: #{comb[name][1]}(#{comb[name][0]} #{comb[name][2]})"
      print_gates(comb, comb[name][0], depth+1, max_depth)
      print_gates(comb, comb[name][2], depth+1, max_depth)
    end

    def part_1
      latches, comb = data

      comb.keys.select { |k| k =~ /^z/ }.sort.map { |z|
        get_value(latches, comb, z)
      }.reverse.join.to_i(2)
    end

    def part_2
      latches, comb = data

      swaps = []
      # this is populated by hand after inspecting the circuit for each bad bit
      swaps << ["qjj", "gjc"] # fixes bad bit 11
      swaps << ["z17", "wmp"] # fixes bad bit 17
      swaps << ["z26", "gvm"] # fixes bad bit 26
      swaps << ["z39", "qsb"] # fixes bad bit 39

      swaps.each { |s1, s2| comb[s1],comb[s2] = comb[s2], comb[s1] }

      bad_bit = 45.times.find { |i|
        !test_add(latches, comb, 1 << i, 0) ||
        !test_add(latches, comb, 0, 1 << i)
      }

      unless(bad_bit.nil?)
        puts "Bad Bit: #{bad_bit}"
        [bad_bit-1, bad_bit, bad_bit+1].each { |i|
          print_gates(comb, "z%02d" % i)
        }
        return nil
      end

      swaps.flatten.sort.join(",")
    end

    private
      def process_dataset(set)
        init, comb = set.slice_when { _1.size==0 }.to_a
        latches = init.each.with_object({}) { |line, latches|
          next if(line.empty?)
          name, value = line.split(": ")
          latches[name] = value.to_i
        }
        comb = comb.each.with_object({}) { |line, comb|
          line =~ /(\w+) (\w+) (\w+) -> (\w+)/
          comb[$4] = [$1, $2, $3]
        }
        [latches, comb]
      end

  end
end
