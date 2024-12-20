# frozen_string_literal: true

module Year2024
  class Day19 < Solution
    def part_1
      pattern = /^#{Regexp.union(*data[0].split(', '))}+$/
      data[2..].count { |design| design =~ pattern }
    end

    def count_paths(design, pattern, cache)
      return 1 if design.empty?

      cache[design] ||=
        pattern.select { |p| design.start_with?(p) }
               .sum { |p| count_paths(design[p.length..], pattern, cache) }
    end

    def part_2
      pattern = data[0].split(', ')
      cache = {}
      data[2..].sum { |design| count_paths(design, pattern, cache) }
    end
  end
end
