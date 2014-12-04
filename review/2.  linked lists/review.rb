class LinkedList
  attr_accessor :data, :next

  def initialize(data)
    self.data = data
  end

  def add_node(data)
    if self.next.nil?
      self.next = LinkedList.new(data)
    else
      self.next.add_node(data)
    end
    self
  end

  def to_s
    str = ""
    str += self.data.to_s
    str += ", #{self.next.to_s}" unless self.next.nil?
    str
  end
end

# Problem 2.1: Remove all duplicates in a linked list.  How would you solve it if a temp buffer
# is not allowed? # presort list first
class LinkedList
  def remove_duplicates!(buffer = [])
    return if self.nil?
    
    buffer << self.data

    return if self.next.nil?
    if buffer.include?(self.next.data)
      self.next = self.next.next
      self.remove_duplicates!(buffer) # to remove repeated values
    else
      self.next.remove_duplicates!(buffer)
    end
  end
end
# a = LinkedList.new("a").add_node("b").add_node("c").add_node("b").add_node("b").add_node("a")
# a.remove_duplicates!
# a.to_s
# => "a,b,c"

# Problem 2.2: Implement an algorithm to find k to the last element of a linked list
class LinkedList
  def length
    length = 1
    if self.next.nil?
      return length
    else
      length += self.next.length
    end
  end

  def kth_to_last(k)
    if self.length == k
      return data
    else
      self.next.kth_to_last(k)
    end
  end
end

# a = LinkedList.new("a").add_node("b").add_node("c").add_node("b").add_node("b").add_node("a")
# a.kth_to_last(2)
# => b

# Problem 2.3: Remove a node from a list given its data
class LinkedList
  def remove_node!(data)
    if self.next.nil?
      return false
    elsif self.next.data == data
      self.next = self.next.next
      return true
    else
      self.next.remove_node(data)
    end
  end
end
# a = LinkedList.new("a").add_node("b").add_node("c")
# a.remove_node!("b")
# a.to_s
# => "a,c"


# Problem 2.4: Partition a linkedlist given a value such that all values less than x
# comes before all nodes that comes after x
class LinkedList
  def partition(x, left = nil, right = nil)
    return if self.nil?

    if data <= x
      if left.nil?
        left = LinkedList.new(self.data)
      else
        left.add_node(self.data)
      end
    else
      if right.nil?
        right = LinkedList.new(self.data)
      else
        right.add_node(self.data)
      end
    end

    return [left, right] if self.next.nil?
    self.next.partition(x, left, right)
  end
end
# LinkedList.new(1).add_node(5).add_node(2).add_node(4).partition(3).map(&:to_s)
# => ["1, 2", "5, 4"]

# Problem 2.5a: You have two numbers stored as a linked list in reverse order.  Write a function
# that adds the two numbers together and return it as a linked list
class LinkedList
  def last
    return self if self.next.nil?
    
    self.next.last
  end


  def self.add(x,y, carry = nil, first = true)
    sum = 0
    sum += x.data unless x.nil?
    sum += y.data unless y.nil?
    sum += carry unless carry.nil?

    out = nil
    
    if sum >= 10
      carry = 1
      ones = sum.to_s.split("")[-1].to_i
      if first
        out = LinkedList.new(carry).add_node(ones)
      else
        out = LinkedList.new(ones)
      end
    else
      out = LinkedList.new(sum)
    end

    return out if x.next.nil? && y.next.nil?
    out.last.next = LinkedList.add(x.next, y.next, carry, false)
    out
  end
end

# 123 + 947
# x = LinkedList.new(3).add_node(2).add_node(1)
# y = LinkedList.new(7).add_node(4).add_node(9)
# LinkedList.add(x,y).to_s
# "1, 0, 7, 1"

# Problem 2.5b: What if the numbers are stored in forward order?
class LinkedList
  def reverse
    out = LinkedList.new(self.data)
    if self.next.nil?
      return out
    else
      out = self.next.reverse.add_node(self.data)
    end
    out
  end

  def self.add_forward(x,y)
    add(x.reverse, y.reverse).reverse
  end
end

# x = LinkedList.new(1).add_node(2).add_node(3)
# y = LinkedList.new(9).add_node(4).add_node(7)
# LinkedList.add_forward(x,y).to_s
# "1, 7, 0, 1"

# Problem 2.6: Given a circular linked list, return the node at which the loop starts
class LinkedList
  # returns nil if no collision is found.  Otherwise, return the node at which
  # collision occurs
  def detect_collision(p1 = nil, p2 = nil)
    if p1.nil?
      p1 = self
      p2 = self
    end

    p1 = pointer_next(p1)
    p2 = pointer_next_two(p2)

    if p1 == p2
      return p1
    end

    return nil if p2.next.nil?

    detect_collision(p1, p2)
  end

  def pointer_next(list)
    if list.next.nil?
      list
    else
      list.next
    end
  end

  def pointer_next_two(list)
    if list.next.nil?
      list
    elsif list.next.next.nil?
      list.next
    else
      list.next.next
    end
  end

  def detect_circular
    collision = self.detect_collision

    return if collision.nil?

    p1 = self
    p2 = collision

    until p1 == p2
      p1 = pointer_next(p1)
      p2 = pointer_next(p2)
    end

    p1.data
  end
end

# create the circular list
# list = LinkedList.new("a").add_node("b").add_node("c").add_node("d").add_node("e")
# list.last.next = list.next.next

# list.detect_circular
# => "c"

# Problem 2.7: Check if a linked list is a palindrome
class LinkedList
  # Method 1: reverse and compare
  def is_palindrome?
    list1 = self
    list2 = self.reverse

    LinkedList.check_equal(list1, list2)
  end

  def self.check_equal(list1, list2)
    return false if list1.data != list2.data
    return true if list1.next.nil?

    self.check_equal(list1.next, list2.next)
  end

  # Method 2: recursive subdivision
  def is_palindrome2?
    if self.length == 1
      return true
    elsif self.length == 2
      return true if self.data == self.next.data
    else
      if self.data == self.last.data
        self.next.sublist(self.length - 2).is_palindrome?
      else
        false
      end
    end
  end

  def sublist(length)
    out = LinkedList.new(self.data)
    return out if length <= 1
    
    out.next = self.next.sublist(length - 1)
    out
  end
end

# LinkedList.new("a").add_node("b").add_node("c").add_node("b").add_node("a").is_palindrome?
# => true
# LinkedList.new("a").add_node("b").add_node("c").add_node("b").add_node("a").is_palindrome2?
# => true












































































































