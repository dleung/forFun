class LinkedList
  attr_accessor :data, :next_node

  def initialize(data)
    self.data = data
    self.next_node = self
  end

  def length
    length = 1
    if next_node.data
      return length
    else
      length += self.next_node.length
    end

    length
  end

  def push(data)
    if next_node.nil?
      self.next_node = LinkedList.new(data)
    else
      self.next_node.add_node(data)
    end

    self
  end

  def shift(data)
    self.next_node = self.dup
    self.data = data
    self
  end

  def to_s
    str = ""
    str += "#{data.to_s}"
    str += ", #{next_node.to_s}" unless next_node.nil?
    str
  end

  def copy
    list = LinkedList.new(data)

    if self.next_node.nil?
      return list
    else
      list.push(self.next_node.copy)
    end

    list
  end
end

ll = LinkedList.new("f")
ll.push("g")
ll.to_s
ll.shift("a")
ll.copy.to_s