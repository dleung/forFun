# Problem 46: Truth tables for logical expression
def not_(a)
	return false if a == true
	true
end

def and_(a,b)
	if a
		if b
			return true
		end
	end

	false
end

def or_(a,b)
	if a
		true
	elsif b
		true
	end
end

def nand_(a,b)
	not_(and_(a,b))
end

def nor_(a,b)
	not_(or_(a,b))
end

def xor_(a,b)
	and_(not_(a), not_(b))
end

def myimpl(a,b)
	and_(a, not_(b))
end

def myequ(a,b)
	or_(and_(a,b), and_(not_(a),not_(b)))
end

def table2(proc)
	a = b = true
	puts "a = #{a} | b = #{b} | result = #{proc.call(a,b)}"
	a = false
	puts "a = #{a} | b = #{b} | result = #{proc.call(a,b)}"
	b = false
	a = true
	puts "a = #{a} | b = #{b} | result = #{proc.call(a,b)}"
	a = false
	puts "a = #{a} | b = #{b} | result = #{proc.call(a,b)}"
end

# table2(->(a,b){and_(a, or_(a,b))})
# a = true | b = true | result = true
# a = false | b = true | result = false
# a = true | b = false | result = true
# a = false | b = false | result = false

# Problem 49: Gray code
class Fixnum
	def gray(hash = {})
		out = []

		if self == 1
			ans = ["0", "1"]
			return ans, {1 => ans}
		else
			["0","1"].each do |pre|
				grayn = if hash[self-1]
					puts hash.inspect
					hash[self-1]
				else
					res, hash = (self-1).gray(hash)
					hash[self-1] = res
					res
				end

				grayn.each do |o|
					out << pre + o
				end
			end
		end

		[out, hash]
	end
end

a, _ = 3.gray; a
# => ["000", "001", "010", "011", "100", "101", "110", "111"]

# Problem 50: Huffman code
def huffman_tree(frequency_array = [], tree = [])
	# Creates the bottom leave nodes if tree is empty
	if tree.empty?
		frequency_array.each do |freq|
			tree << [freq.keys[0] => freq.values[0]]
		end
	end

	if frequency_array.size == 2
		# At this point, tree should only have 1 unlinked node
		ele2 = tree.pop
		ele1 = tree.pop
		tree << ["r", ele1, ele2]
		return tree
	else
		fa = frequency_array.dup
		ele2 = fa.pop
		ele1 = fa.pop

		new_freq = {ele1.keys[0] + ele2.keys[0] => ele1.values[0] + ele2.values[0]}

		# Links the new frequency node to the previous element in the tree
		key1 = ele1.keys[0]
		key2 = ele2.keys[0]
		tree_ele1 = tree_ele2 = nil

		tree.each do |ele|
			if ele[0].keys[0] == key1
				tree_ele1 = tree.delete(ele)
				break
			end
		end

		tree.each do |ele|
			if ele[0].keys[0] == key2
				tree_ele2 = tree.delete(ele)
				break
			end
		end

		tree << [new_freq, tree_ele1, tree_ele2]

		# Insert the combined frequency + symbol into the frequency array
		indx = fa.size - 1
		loop do
			if fa[indx].values[0] > new_freq.values[0] || indx == 0
				fa.insert(indx + 1, new_freq)
				break
			end
			indx -= 1
		end

		tree = huffman_tree(fa, tree)
	end

	if tree.size == 1
		tree[0]
	else
		tree
	end
end

def walk(huffman_tree, code = "")
	out = []

	if huffman_tree[1].nil? && huffman_tree[2].nil?
		out.concat([huffman_tree[0].keys[0] => code])
	end

	# Assigns left node to be "0"
	if !huffman_tree[1].nil?
		out.concat(walk(huffman_tree[1], code + "0"))
	end
	
	# Assigns right node to be "0"
	if !huffman_tree[2].nil?
		out.concat(walk(huffman_tree[2], code + "1"))
	end

	out
end

def huffman(frequency_array = [])
	raise "Frequency map must be defined in form of {sym => count}" if frequency_array.empty?
	frequency_array.sort! {|x,y| y.values[0] <=> x.values[0]}
	tree = huffman_tree(frequency_array)
	walk(tree)
end

huffman([{"a" => 45}, {"b" => 13}, {"c" => 12}, {"d" => 16}, {"e" => 9}, {"f" => 5}])
=> [{"a"=>"0"}, {"d"=>"100"}, {"e"=>"1010"}, {"f"=>"1011"}, {"b"=>"110"}, {"c"=>"111"}]
























