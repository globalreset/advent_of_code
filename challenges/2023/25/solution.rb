# frozen_string_literal: true
module Year2023
  class Day25 < Solution
    def parse_input(input)
      graph = Hash.new { |h, k| h[k] = [] }
      input.each do |line|
        source, targets = line.split(': ')
        targets = targets.split(' ')
        targets.each do |target|
          graph[source] << target
          graph[target] << source  # Undirected graph
        end
      end
      graph
    end

    def count_group_size(graph, start)
      seen = Set.new([start])
      queue = [start]
      
      while !queue.empty?
        node = queue.shift
        graph[node].each do |neighbor|
          next if seen.include?(neighbor)
          seen.add(neighbor)
          queue << neighbor
        end
      end
      
      seen.size
    end

    def find_min_cut(graph)
      vertices = graph.keys
      n = vertices.size
      
      # Try more iterations to ensure we find the correct cut
      3000.times do
        # Create a copy of the graph that we can modify
        g = graph.transform_values(&:dup)
        
        # Keep track of merged vertices for group size calculation
        groups = {}
        vertices.each { |v| groups[v] = [v] }
        
        # Keep merging vertices until only 2 remain
        remaining = vertices.dup
        while remaining.size > 2
          # Pick a random edge and merge its vertices
          v = remaining.sample
          next if g[v].empty?
          u = g[v].sample
          
          # Merge u into v
          g[v].concat(g[u]).reject! { |x| x == v || x == u }
          remaining.delete(u)
          
          # Keep track of which vertices were merged together
          groups[v].concat(groups[u])
          groups.delete(u)
          
          # Update all references to u to point to v instead
          g.each_value do |edges|
            edges.map! { |x| x == u ? v : x }
          end
        end
        
        # Count edges between the two remaining vertices
        cut_size = g[remaining.first].size
        if cut_size == 3
          # Found it! Count group sizes
          group1_size = groups[remaining.first].size
          group2_size = n - group1_size
          return group1_size * group2_size
        end
      end
      
      nil  # No solution found
    end

    def part_1
      require 'set'
      graph = parse_input(data)
      find_min_cut(graph)
    end

    def part_2
      "Merry Christmas! 🎄"
    end

    private

    # Uncomment this to use example data during development
    #def data
    #  <<~EOF.lines
    #    jqt: rhn xhk nvd
    #    rsh: frs pzl lsr
    #    xhk: hfx
    #    cmg: qnr nvd lhk bvb
    #    rhn: xhk bvb hfx
    #    bvb: xhk hfx
    #    pzl: lsr hfx nvd
    #    qnr: nvd
    #    ntq: jqt hfx bvb xhk
    #    nvd: lhk
    #    lsr: lhk
    #    rzs: qnr cmg lsr rsh
    #    frs: qnr lhk lsr
    #  EOF
    #end
  end
end
