# frozen_string_literal: true
module Year2024
  class Day09 < Solution
    def part_1
      files, free = data.chomp.chars.map(&:to_i)
                        .each_with_index.partition { |n, i| i%2==0 }
                        .map{ |a| a.map(&:first) }
      pos = 0
      checksum = 0
      leftId = 0
      rightId = files.size-1
      rightBytes = files.pop 
      while(!files.empty?)
        # left
        bytes = files.shift
        checksum += (pos...(pos+bytes)).to_a.sum * leftId
        leftId += 1
        pos += bytes
        # right
        if(!free.empty?)
          freeBytes = free.shift
          while(freeBytes > 0)
            break if(rightBytes == 0 && files.empty?)
            if(rightBytes == 0)
              rightBytes = files.pop
              rightId -= 1
            end
            bytes = [freeBytes, rightBytes].min
            checksum += (pos...(pos+bytes)).to_a.sum * rightId
            pos += bytes
            freeBytes -= bytes
            rightBytes -= bytes
          end
        end
      end
      if(rightBytes > 0) #grab remainder
        checksum += (pos...(pos+rightBytes)).to_a.sum * rightId
      end
      checksum 
    end

    def part_2
      fileLinkedList = Struct.new(:id, :bytes, :next)
      fileNodes, freeNodes = [], []
      head = fileLinkedList.new(nil, 0, nil) 
      tail = head
      data.chomp.chars.map(&:to_i)
          .each_with_index { |n, i|
            if(i.even?)
              tail = (tail.next = fileLinkedList.new(i/2, n, nil))
              fileNodes << tail
            else
              tail = (tail.next = fileLinkedList.new(nil, n, nil))
              freeNodes << tail
            end
          }
      head = head.next

      fileNodes.reverse_each { |file|
        freeNodes.each_with_index { |free, idx|
          if free.bytes < file.bytes
            break if free.next == file
            next
          end
          if(free.bytes > file.bytes)
            remainder = fileLinkedList.new(nil, free.bytes-file.bytes, free.next)
            free.next = remainder
            freeNodes[idx] = remainder
          else
            freeNodes.delete_at(idx)
          end
          free.id = file.id
          free.bytes = file.bytes
          file.id = nil
          break
        }
      }

      checksum = 0
      pos = 0
      curr = head
      while(curr != nil)

        if(curr.id != nil)
          checksum += (pos...(pos+curr.bytes)).to_a.sum * curr.id
        end
        pos += curr.bytes
        curr = curr.next
      end
      checksum
    end

    private
      #def data
      #  "2333133121414131402"
      #end
  end
end
