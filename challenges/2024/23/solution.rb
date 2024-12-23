# frozen_string_literal: true
module Year2024
  class Day23 < Solution
    def part_1
      net = data.map { |line| line.split("-") }.each.with_object({}) { |(a,b), net|
        ((net[a] ||= Set.new) << b) && ((net[b] ||= Set.new) << a)
      }

      thruple = Set.new
      net.keys.each { |n1|
        net[n1].each { |n2|
          net[n2].each { |n3|
            next if n3 == n1
            thruple << [n1, n2, n3].to_set if(net[n3].include?(n1))
          }
        }
      }
      thruple.count { |t| t.any? { |n| n.start_with?("t") } }
    end

    def build_group(nodes, group, net)
      return group if nodes.empty?
      nodes.map { |n|
        # recursively check the union of current nodes under consideration and 
        # all the nodes connected to 'n' while considering adding 'n' to the group
        newNodes = nodes & net[n]
        nodes -= [n] # remove from future consideration as it's redundant
        build_group(newNodes, group + [n], net)
      }.max_by(&:size)
    end

    def part_2
      net = data.map { |line| line.split("-") }.each.with_object({}) { |(a,b), net|
        ((net[a] ||= Set.new) << b) && ((net[b] ||= Set.new) << a)
      }

      max_group = []
      net.keys.sort_by { |n| -net[n].size }.map { |start|
        # skip any node with starting network < current max
        next if net[start].size + 1 <= max_group.size
        max_group = [max_group, build_group(net[start], [start], net)].max_by(&:size)
      }
      max_group.sort.join(",")

      # For next time, remind myself that NetworkX exists
      # require 'networkx'
      # g = NetworkX::Graph.new
      # data.each { |line|
      #   g.add_edge(*line.split("-"))
      # }

      # NetworkX.find_cliques(g).max_by(&:size).sort.join(",")

    end
  end
end
