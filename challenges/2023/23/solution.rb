# frozen_string_literal: true
require 'set'

module Year2023
  class Day23 < Solution
    def find_longest_path(grid, respect_slopes = true)
      start_x = grid[0].index('.')
      end_x = grid[-1].index('.')
      start = [0, start_x]
      goal = [grid.size - 1, end_x]
      
      visited = Set.new
      max_length = 0
      
      # Stack will contain [pos, steps, visited_set]
      stack = [[start, 0, Set.new]]
      
      while !stack.empty?
        pos, steps, visited = stack.pop
        
        if pos == goal
          max_length = [max_length, steps].max
          next
        end
        
        next if !valid_position?(pos, grid) || visited.include?(pos)
        
        current = grid[pos[0]][pos[1]]
        next if current == '#'
        
        visited.add(pos)
        
        moves = if respect_slopes
          case current
          when '>'
            [[0, 1]]
          when '<'
            [[0, -1]]
          when '^'
            [[-1, 0]]
          when 'v'
            [[1, 0]]
          else
            [[0, 1], [0, -1], [1, 0], [-1, 0]]
          end
        else
          [[0, 1], [0, -1], [1, 0], [-1, 0]]
        end
        
        moves.each do |dx, dy|
          new_pos = [pos[0] + dx, pos[1] + dy]
          stack.push([new_pos, steps + 1, visited.dup])
        end
      end
      
      max_length
    end

    def find_intersections(grid)
      intersections = Set.new
      start_x = grid[0].index('.')
      end_x = grid[-1].index('.')
      
      # Add start and end points
      intersections.add([0, start_x])
      intersections.add([grid.size - 1, end_x])
      
      # Find all points with more than 2 neighbors
      grid.size.times do |i|
        grid[0].size.times do |j|
          next if grid[i][j] == '#'
          neighbors = 0
          [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |di, dj|
            ni, nj = i + di, j + dj
            if valid_position?([ni, nj], grid) && grid[ni][nj] != '#'
              neighbors += 1
            end
          end
          intersections.add([i, j]) if neighbors > 2
        end
      end
      intersections
    end

    def build_graph(grid, intersections)
      graph = Hash.new { |h, k| h[k] = {} }
      
      intersections.each do |point|
        stack = [[point, 0, Set[point]]]
        
        while !stack.empty?
          pos, dist, visited = stack.pop
          
          if dist > 0 && intersections.include?(pos)
            graph[point][pos] = [dist, graph[point][pos]].compact.max
            next
          end
          
          [[0, 1], [0, -1], [1, 0], [-1, 0]].each do |di, dj|
            ni, nj = pos[0] + di, pos[1] + dj
            next_pos = [ni, nj]
            
            if valid_position?(next_pos, grid) && grid[ni][nj] != '#' && !visited.include?(next_pos)
              stack.push([next_pos, dist + 1, visited + [next_pos]])
            end
          end
        end
      end
      graph
    end

    def find_longest_path_in_graph(graph, start, goal, visited = Set.new)
      return 0 if start == goal
      
      max_dist = -Float::INFINITY
      visited.add(start)
      
      graph[start].each do |next_point, dist|
        next if visited.include?(next_point)
        path_dist = find_longest_path_in_graph(graph, next_point, goal, visited)
        max_dist = [max_dist, dist + path_dist].max if path_dist >= 0
      end
      
      visited.delete(start)
      max_dist
    end

    def valid_position?(pos, grid)
      row, col = pos
      row >= 0 && row < grid.size && col >= 0 && col < grid[0].size
    end

    def part_1
      grid = data.map(&:chomp)
      find_longest_path(grid)
    end

    def part_2
      grid = data.map(&:chomp)
      start_x = grid[0].index('.')
      end_x = grid[-1].index('.')
      start = [0, start_x]
      goal = [grid.size - 1, end_x]
      
      intersections = find_intersections(grid)
      graph = build_graph(grid, intersections)
      find_longest_path_in_graph(graph, start, goal)
    end
  end
end
