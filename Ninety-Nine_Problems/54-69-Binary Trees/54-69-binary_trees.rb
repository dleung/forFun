class Node
	attr_accessor :value, :left, :right
	
	def initialize(value, left = nil, right = nil)
		self.value = value
		self.left = left
		self.right = right
	end

	def to_s
		str = "(T #{value} "
		str += left ? left.to_s : "."
		str += " "
		str += right ? right.to_s : "."
		str += " )"
		str
	end
end


# tree = Node.new('a', Node.new('b', Node.new('d'), Node.new('e')), Node.new('c', nil, Node.new('f', Node.new('g'), nil)))

# Problem 55: Construct completely balanced binary trees
def c_balanced(nodes, value)
	trees = [nil]

	if nodes >= 1
		trees = [Node.new(value)]
		nodes -= 1
	end
	
	if nodes < 1
		return trees
	elsif nodes.even?
		subtrees = c_balanced(nodes/2, value)

		trees = generate_tree_permutations_from_subtree(trees, subtrees)
	elsif nodes.odd?
		smaller_trees = c_balanced((nodes / 2.0).floor, value)
		bigger_trees = c_balanced((nodes / 2.0).ceil, value)

		trees = generate_tree_permutations_from_subtrees(trees, smaller_trees, bigger_trees)
	end

	trees
end

def generate_tree_permutations_from_subtrees(trees, subtrees1, subtrees2 = nil)
	[subtrees1, subtrees2].permutation.to_a.inject([]) do |ftrees, combined|
		ftrees.concat(combined[0].product(combined[1]).map do |combo|
			trees.map do |node|
				node_ = node.dup
				node_.left = combo[0]
				node_.right = combo[1]
				node_
			end
		end.flatten)
		ftrees
	end
end

def generate_tree_permutations_from_subtree(trees, subtrees)
	subtrees.product(subtrees).inject([]) do |ftrees, combo|
		ftrees.concat(trees.map do |node|
				node_ = node.dup
				node_.left = combo[0]
				node_.right = combo[1]
				node_
			end)
		ftrees
	end
end
# c_balanced(5, "foo").each {|a| puts a.to_s}
# (T foo (T foo . (T foo . . ) ) (T foo . (T foo . . ) ) )
# (T foo (T foo . (T foo . . ) ) (T foo (T foo . . ) . ) )
# (T foo (T foo (T foo . . ) . ) (T foo . (T foo . . ) ) )
# (T foo (T foo (T foo . . ) . ) (T foo (T foo . . ) . ) )

# Problem 56: Symmetric binary trees
class Node
	def is_symmetric?
		self.left.is_mirror?(self.right)
	end

	def is_mirror?(node)
		if self.left.nil? ^ node.right.nil?
			return false
		elsif self.right.nil? ^ node.left.nil?
			return false
		elsif self.left.nil? && self.right.nil? && self.right.nil? && self.left.nil?
			return true
		end

		leftbool = self.left ? self.left.is_mirror?(node.right) : true
		rightbool = self.right ? self.right.is_mirror?(node.left) : true

		leftbool && rightbool
	end
end

# Node.new('a', Node.new('b'), Node.new('c')).is_symmetric?
# => true

# Problem 57: Binary search trees(dictionaries)
class Node
	def add_value(val)
		node = Node.new(val)

		raise "Duplicate found" if node.value == self.value
		if node.value > self.value
			if self.right.nil?
				self.right = node
			else
				self.right.add_value(val)
			end
		else
			if self.left.nil?
				self.left = node
			else
				self.left.add_value(val)
			end
		end

		self
	end
end

# Node.new(2).add_value(3).add_value(0).to_s
# => "(T 2 (T 0 . . ) (T 3 . . ) )"

class Array
	def to_tree
		tree = Node.new(self.shift)
		until self.empty?
			tree.add_value(self.shift)
		end
		tree
	end
end

# [3,2,5,7,1].to_tree.to_s
# => "(T 3 (T 2 (T 1 . . ) . ) (T 5 . (T 7 . . ) ) )"
# [5,3,18,1,4,12,21].to_tree.is_symmetric?
# => true
# [3,2,5,7,4].to_tree.is_symmetric?
# => false

# Problem 58: Generate-and-test paradigm
def symmetric_balanced_trees(nodes, value)
	c_balanced(nodes, value).select {|tree| tree.is_symmetric?}
end

# symmetric_balanced_trees(5, 'x').each {|tree| puts tree.to_s}
# (T x (T x . (T x . . ) ) (T x (T x . . ) . ) )
# (T x (T x (T x . . ) . ) (T x . (T x . . ) ) )

# Problem 59: Construct height-balanced binary trees
def h_bal_trees(height, value)
	trees = [nil]

	if height >= 1
		trees = [Node.new(value)]
	end

	if height == 2
		all_trees = []

		h_bal_trees(height-1, value).each do |balanced_trees|
			all_trees.concat(trees.map do |tree|
				tree_ = tree.dup
				tree_.left = balanced_trees
				tree_
			end)

			all_trees.concat(trees.map do |tree|
				tree_ = tree.dup
				tree_.right = balanced_trees
				tree_
			end)

			all_trees.concat(trees.map do |tree|
				tree_ = tree.dup
				tree_.left = balanced_trees
				tree_.right = balanced_trees
				tree_
			end)

			all_trees.concat(trees.map do |tree|
				tree.dup
			end)
		end
		trees = all_trees
	elsif height > 2
		all_trees = []		

		h_bal_trees(height-1, value).repeated_permutation(2).each do |combination_trees|
			next if combination_trees[0].left.nil? &&
				combination_trees[1].left.nil? &&
				combination_trees[0].right.nil? &&
				combination_trees[1].right.nil?

			all_trees.concat(trees.map do |tree|
				tree_ = tree.dup
				tree_.left = combination_trees[0]
				tree_.right = combination_trees[1]
				tree_
			end)
		end

		trees = all_trees		
	end

	trees
end
h_bal_trees(3, 'x').each {|a| puts a.to_s}
# (T x (T x (T x . . ) . ) (T x (T x . . ) . ) )
# (T x (T x (T x . . ) . ) (T x . (T x . . ) ) )
# (T x (T x (T x . . ) . ) (T x (T x . . ) (T x . . ) ) )
# (T x (T x (T x . . ) . ) (T x . . ) )
# (T x (T x . (T x . . ) ) (T x (T x . . ) . ) )
# (T x (T x . (T x . . ) ) (T x . (T x . . ) ) )
# (T x (T x . (T x . . ) ) (T x (T x . . ) (T x . . ) ) )
# (T x (T x . (T x . . ) ) (T x . . ) )
# (T x (T x (T x . . ) (T x . . ) ) (T x (T x . . ) . ) )
# (T x (T x (T x . . ) (T x . . ) ) (T x . (T x . . ) ) )
# (T x (T x (T x . . ) (T x . . ) ) (T x (T x . . ) (T x . . ) ) )
# (T x (T x (T x . . ) (T x . . ) ) (T x . . ) )
# (T x (T x . . ) (T x (T x . . ) . ) )
# (T x (T x . . ) (T x . (T x . . ) ) )
# (T x (T x . . ) (T x (T x . . ) (T x . . ) ) )

# Problem 60: Construct height-balanced binary trees with a given number of nodes.
def min_hbal_nodes(height)
	return 1 if height == 1
	return 2 if height == 2

	height + height - 2
end

def max_hbal_nodes(height)
	2 ** height -1
end


def min_hbal_height(nodes)
	return 0 if nodes == 0
	min_hbal_height(nodes / 2) + 1
end

def max_hbal_height(nodes)
	return 1 if nodes == 1

	((0.5) * nodes + 1).floor
end

class Node
	def total
		count = 1
		
		unless self.left.nil?
			count += self.left.total
		end

		unless self.right.nil?
			count += self.right.total
		end

		count
	end
end

def hbal_trees_with_nodes(nodes, value)
	trees = []

	(min_hbal_height(nodes)..max_hbal_height(nodes)).each do |height|
		trees.concat(h_bal_trees(height, value))
	end
	trees.select {|a| a.total == nodes}
end

# hbal_trees_with_nodes(4, "x")
# => (T x (T x (T x . . ) . ) (T x . . ) )
# (T x (T x . (T x . . ) ) (T x . . ) )
# (T x (T x . . ) (T x (T x . . ) . ) )
# (T x (T x . . ) (T x . (T x . . ) ) )

# Problem 61: Count the leaves of a binary tree
class Node
	def leaf_count
		return 1 if self.left.nil? && self.right.nil?
		count = 0

		unless self.left.nil?
			count += self.left.leaf_count
		end

		unless self.right.nil?
			count += self.right.leaf_count
		end

		count		
	end
end
# Node.new('x', Node.new('x')).leaf_count
# => 1

# Problem 62: Collect the leaves of a binary tree in a list
class Node
	def leaves
		leaves = []

		return [self.value] if self.left.nil? && self.right.nil?

		unless self.left.nil?
			leaves.concat(self.left.leaves)
		end

		unless self.right.nil?
			leaves.concat(self.right.leaves)
		end

		leaves
	end
end

# Node.new('a', Node.new('b'), Node.new('c', Node.new('d'), Node.new('e'))).leaves
# => ["b", "d", "e"]

class Node
	def at_level(level)
		out = []

		if level == 1
			out << self.value
		else
			unless self.left.nil?
				out.concat(self.left.at_level(level-1))
			end

			unless self.right.nil?
				out.concat(self.right.at_level(level-1))
			end
		end

		out
	end
end

# Node.new('a', Node.new('b'), Node.new('c', Node.new('d'), Node.new('e'))).at_level(2)
# => ["b","c"]

# Problem 63: Construct a complete binary tree
def complete_binary_tree(nodes, value, address = 1)
	if address > nodes
		return nil
	end

	Node.new(value, complete_binary_tree(nodes, value, 2 * address), complete_binary_tree(nodes, value, 2 * address + 1))
end
# complete_binary_tree(6, "x")
# => "(T x (T x (T x . . ) (T x . . ) ) (T x (T x . . ) . ) )"

# Problem 64: Layout Binary Tree (1)
# x(v) is equal to the position of the node v in the inorder sequence
# y(v) is equal to the depth of the node v in the tree
class PositionedNode < Node
	attr_accessor :x, :y
	def initialize(value, left = nil, right = nil, x = 0, y = 0)
		self.value = value
		self.left = left
		self.right = right
		self.x = x
		self.y = y
	end

	def to_s
		str = "T[#{x.to_s}, #{y.to_s}]"
		str += "(#{value.to_s} "
		str += left ? left.to_s : "."
		str += " "
		str += right ? right.to_s : "."
		str += " )"
		str
	end
end

class Node
	def layout_binary_tree(level = 1, x_pos = 1)
		tree = PositionedNode.new(self.value, nil, nil, x_pos, level)

		unless self.left.nil?
			tree.left, x_pos = self.left.layout_binary_tree(level + 1, x_pos)
			x_pos += 1
		end

		tree.x = x_pos

		unless self.right.nil?
			tree.right, x_pos = self.right.layout_binary_tree(level + 1, x_pos + 1)
		end

		[tree, x_pos]
	end
end

# Node.new('a', Node.new('b', nil, Node.new('c')), Node.new('d')).layout_binary_tree[0].to_s
# => "T[3, 1](a T[1, 2](b . T[2, 3](c . . ) ) T[4, 2](d . . ) )"

# ['n','k','m','c','a','h','g','e','u','p','s','q'].to_tree.layout_binary_tree[0].to_s
# "T[8, 1](n T[6, 2](k T[2, 3](c T[1, 4](a . . ) T[5, 4](h T[4, 5](g T[3, 6](e . . ) . ) . ) ) T[7, 3](m . . ) ) T[12, 2](u T[9, 3](p . T[11, 4](s T[10, 5](q . . ) . ) ) . ) )"

# Problem 65: Layout Binary Tree 2
class Node
	# Given a tree, calculate the depth
	def max_depth
		if self.left.nil? && self.right.nil?
			return 1
		end

		left_depth = right_depth = 1
		if !self.left.nil?
			left_depth += self.left.max_depth
		end

		if !self.right.nil?
			right_depth += self.right.max_depth
		end

		[left_depth, right_depth].max
	end
end

class Node
	def layout_binary_tree2
		generate_tree_layout2(self.max_depth)[0]
	end

	def generate_tree_layout2(max_depth, level = 1, x_pos = 1)
		tree = PositionedNode.new(self.value, nil, nil, x_pos, level)

		distance = (2 ** (max_depth - 1 - level))

		unless self.left.nil?
			x_pos = x_pos - distance unless x_pos == 1
			tree.left, x_pos = self.left.generate_tree_layout2(max_depth, level + 1, x_pos)
			x_pos = x_pos + distance
		end
		
		tree.x = x_pos

		unless self.right.nil?
			tree.right, _ = self.right.generate_tree_layout2(max_depth, level + 1, x_pos + distance)
		end

		[tree, x_pos]
	end
end

# Node.new('a', Node.new('b', nil, Node.new('c')), Node.new('d')).layout_binary_tree2.to_s
# => "T[3, 1](a T[1, 2](b . T[2, 3](c . . ) ) T[5, 2](d . . ) )"


# ['n','k','m','c','a','e','d','g','u','p','q'].to_tree.layout_binary_tree2.to_s
# => "T[15, 1](n T[7, 2](k T[3, 3](c T[1, 4](a . . ) T[5, 4](e T[4, 5](d . . ) T[6, 5](g . . ) ) ) T[11, 3](m . . ) ) T[23, 2](u T[19, 3](p . T[21, 4](q . . ) ) . ) )"

# Problem 67: String representation of binary tree
class Node
	def to_string
		str = value
		if left || right
			str += "("
			str += left.to_string if left
			str += ","
			str += right.to_string if right
			str += ")"
		end
		str
	end
end
# Node.new('a', Node.new('b', Node.new('d'), Node.new('e')), Node.new('c', nil, Node.new('f', Node.new('g')))).to_string
# => "a(b(d,e),c(,f(g,)))"

def tree_from_string(str)
	tree = Node.new(str[0])

	left_str, right_str = find_left_right(str)

	unless left_str == ""
		tree.left = tree_from_string(left_str)
	end

	unless right_str == ""
		tree.right = tree_from_string(right_str)
	end

	tree
end

def find_left_right(str)
	nested = 0
	left = []
	right = []
	comma_found = false

	str[1..-1].each_char do |ele|
		if ele == "("
			nested += 1
		elsif ele == ")"
			nested -= 1
		elsif ele == "," && nested == 1
			comma_found = true
			next
		end

		if comma_found
			right << ele
		elsif !comma_found
			left << ele
		end
	end
	left.shift # Discard leftmost parenthesis
	right.pop # Discard rightmost parenthesis
	[left.join(""), right.join("")]
end

# tree_from_string("a(b(d,e),c(,f(g,)))").to_s
# => "(T a (T b (T d . . ) (T e . . ) ) (T c . (T f (T g . . ) . ) ) )"













