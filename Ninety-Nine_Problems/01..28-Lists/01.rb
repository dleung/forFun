# For simple problems, I will not use the built-in method

# Problem 1: Find the last element of a list
class Array
	# Without using built in #last
	def mylast
		if self.size == 1
			return self[0]
		else
			self[1..-1].mylast
		end
	end
end
# [1,2,3].mylast
# => 3

# Problem 2: Find the last but one element of a list
class Array
	def lastN(n)
		if self.size == n
			return self[0]
		else
			self[1..-1].lastN(n)
		end
	end
end

# [1,2,3,4].lastN(2)
# => 3

# Problem 3: Find the Kth element of a list
class Array
	def kth(n)
		if n == 0
			return self[0]
		else
			self[1..-1].kth(n-1)
		end
	end
end

# [1,2,3,4,5].kth(1)
# => 2

# Problem 4: Find the number of elements of a list
class Array
	def my_size
		size = 1

		if self[0].nil?
			size = 0
		else
			size += self[1..-1].my_size
		end

		size
	end
end

# [1,2,4,5,6].my_size
# => 5

# Problem 5: Reverse a list
class Array
	def my_reverse
		out = [self[-1]]

		if self[0].nil?
			return []
		else
			out = out + self[0..-2].my_reverse 
		end

		out
	end
end

# [1,2,3,4,5].my_reverse
# => [5,4,3,2,1]

# Problem 6: Find out whether a list is a palindrome (read the same backwards and forwards)
class Array
	def is_palindrome
		if self[0].nil?
			return true
		else
			if self[0] == self[-1]
				return self[1..-2].is_palindrome
			else
				return false
			end
		end
	end
end
# [1,2,3,2,1].is_palindrome
# => true

# Problem 7: Flatten a nested list structure
class Array
	def my_flatten
		sol = []

		self.each do |i|
			if i.is_a?(Array)
				sol.concat(i.my_flatten)
			else
				sol << i
			end
		end

		sol
	end
end
# [1,2,3,[4,[2,3]],5].my_flatten
# => [1,2,3,4,2,3,5]

# Problem 8: Eliminate consecutive duplicates of list elements
class Array
	def compress
		out = []
		if self[0].nil?
			return out
		else
			if self[0] == self[1]
				out += ([self[1]] + self[2..-1]).compress
			else
				out += ([self[0]] + self[1..-1].compress)
			end
		end

		out
	end
end
# [1,2,2,3,4,4,4,5].compress
# => [1,2,3,4,5]

# Problem 9: Pack consecutive duplicates of list elements into sublists
class Array
	def my_pack
		out = []
		if self[0].nil?
			return out
		else
			index = 0
			a = []
			loop do
				
				if self[index] != self[index+1]
					a << self[index]
					out << a
					out.concat(self[index+1..-1].my_pack)
					break
				else
					a << self[index]
				end

				index += 1
			end
		end

		out
	end
end
# [1,2,2,2,3,4,4,4].my_pack
# => [[1], [2, 2, 2], [3], [4, 4, 4]]

# Problem 10: Run-length encoding of a list
class Array
	def run_length_encode
		out = []
		if self[0].nil?
			return out
		else
			out << [self[0][0], self[0].count]
			out.concat(self[1..-1].run_length_encode)
		end

		out
	end
end
# [1,2,2,2,3,4,4,4].my_pack.run_length_encode
# => [[1, 1], [2, 3], [3, 1], [4, 3]]

# Problem 11: Modified run-length encoding
class Array
	def modified_run_length_encode
		out = []
		if self[0].nil?
			return out
		else
			if self[0].count == 1
				out.concat(self[0])
			else
				out << [self[0][0], self[0].count]
			end

			out.concat(self[1..-1].modified_run_length_encode)
		end

		out
	end
end
# [1,2,2,2,3,4,4,4].my_pack.modified_run_length_encode
# => [1, [2, 3], 3, [4, 3]]

# Problem 12: Decode a run-length encoded list
class Array
	def run_length_decode
		out = []
		if self[0].nil?
			return out
		else
			val = self[0][0]
			count = self[0][1]

			a = []
			self[0][1].times do
				a << self[0][0]
			end
			
			out << a
			out.concat(self[1..-1].run_length_decode)
		end
		out
	end
end

# [[1, 1], [2, 3], [3, 1], [4, 3]].run_length_decode
# => [[1], [2, 2, 2], [3], [4, 4, 4]]

# Problem 13: Run-length encoding of a list (direct solution)
class Array
	def run_length_encode_direct
		out = []
		if self[0].nil?
			return out
		else
			index = 0
			val = self[index]
			count = 1

			loop do	
				if self[index] != self[index+1]
					out << [val, count]
					out.concat(self[index+1..-1].run_length_encode_direct)
					break
				else
					count += 1
				end

				index += 1
			end
		end

		out
	end
end
# [1,2,2,2,3,4,4,4].run_length_encode_direct
# => [[1, 1], [2, 3], [3, 1], [4, 3]]

# Problem 14: Duplicate the elements of a list
class Array
	def duplicate_elements
		out = []
		if self[0].nil?
			return out
		else
			out.concat([self[0], self[0]] + self[1..-1].duplicate_elements)
		end
		out
	end
end
# ['1','b','c','c','d'].duplicate_elements
# => ["1", "1", "b", "b", "c", "c", "c", "c", "d", "d"]

# Problem 15: Duplicate the elements of a list n times
class Array
	def duplicate_elements_n(n = 1)
		out = []
		if self[0].nil?
			return out
		else
			n.times do
				out << self[0]
			end
			out.concat(self[1..-1].duplicate_elements_n(n))
		end
	end
end
# ['1','b','c','c','d'].duplicate_elements_n(3)
# => ["1", "1", "1", "b", "b", "b", "c", "c", "c", "c", "c", "c", "d", "d", "d"]

# Problem 16: Drop every Nth element from a list
class Array
	def drop_every_n(n)
		out = []
		if self[0].nil?
			return out
		else
			i = 0
			while i != n do
				break if self[i].nil?
				out << self[i]
				i += 1
			end

			out.concat(self[(i + 1)..-1].drop_every_n(n)) unless self[i+1].nil?
		end

		out
	end
end
# ['a','b','c','d','e','f','g','h','i','j','k'].drop_every_n(4)
# => ["a", "b", "c", "d", "f", "g", "h", "i", "k"]

# Problem 17: Split a list into two parts
class Array
	def split(n)
		out = []
		first = []
		i = 0
		while i != n
			break if self[i].nil?
			first << self[i]
			i += 1
		end

		out << first

		out << (self[(i+1)..-1]) unless self[i+1].nil?
		out
	end
end
# ['a','b','c','d','e','f','g','h','i','j','k'].split(3)
# => [["a", "b", "c"], ["e", "f", "g", "h", "i", "j", "k"]]

# Problem 18: Extract a slice from a list
class Array
	def slice(m,n)
		out = []
		if m == 0
			j = 0

			until j == n
				break if self[j].nil?
				out << self[j]
				j += 1
			end
		else
			self.shift
			out = self.slice(m-1,n)
		end

		out
	end
end

# ['a','b','c','d','e','f','g','h','i','j','k'].slice(3,7)
# => ["d", "e", "f", "g", "h", "i", "j"]

# Problem 19: Rotate a list N places to the lift
class Array
	def rotate(n)
		out = []
		if n == 0
			return self
		elsif n > 0
			char = self.shift
			out.concat(self)
			out << char
			out = out.rotate(n-1)
		else
			char = self.pop
			out << char
			out.concat(self)
			out = out.rotate(n+1)
		end
		out
	end
end
# ['a','b','c','d','e','f','g','h','i','j','k'].rotate(3)
# => ["d", "e", "f", "g", "h", "i", "j", "k", "a", "b", "c"]
# ['a','b','c','d','e','f','g','h','i','j','k'].rotate(-2)
# => ["j", "k", "a", "b", "c", "d", "e", "f", "g", "h", "i"]

# Problem 20: Remove the Kth element from a list
class Array
	def remove_at(n)
		out = []
		i = 0
		while i != n
			break if self[i].nil?
			out << self[i]
			i += 1
		end

		out.concat(self[(i+1)..-1])
		out
	end
end
# ['a','b','c','d'].remove_at(1)
# => ["a", "c", "d"]

# Problem 21: Insert an element at a given position into a list
class Array
	def insert(char, n)
		out = []
		i = 0
		while i != n
			break if self[i].nil?
			out << self[i]
			i += 1
		end

		out << char
		out.concat(self[(i+1)..-1])
	end
end
# ['a','b','c','d'].insert('new', 1)
# => ["a", "new", "c", "d"]

# Problem 22: Create a list containing all integers within a given range
def range(i, j)
	out = []
	if i > j
		return out
	else
		out << i
		out.concat(self.range(i+1,j))
	end
	out
end
# range(4,9)
# => [4, 5, 6, 7, 8, 9]

# Problem 23: Extract a given number of randomly selected elements from a list
class Array
	def random_select(n)
		out = []
		if n == 0 || self[0].nil?
			return out
		else
			i = 0
			until self[i].nil?
				i += 1
			end

			rand_indx = (rand * (i-1)).round
			out << self[rand_indx]

			out.concat(self[(0...rand_indx)].concat(self[(rand_indx+1)..-1]).random_select(n-1))
		end
		out
	end
end
# ['a','b','c','d','e','f','g','h'].random_select(3)
# => ["h", "d", "b"]

# Problem 24: Draw N different random numbers from set 1..M
def lotto(n, m)
	(1..m).to_a.random_select(n)
end
# lotto(6, 49)
# => [8, 32, 29, 5, 49, 36]

# Problem 25: Generate random permutation of the elements from a list
class Array
	def random_permute
		random_select(self.size)
	end
end
# ['a','b','c','d','e','f','g','h'].random_permute
# => ["c", "e", "a", "f", "b", "h", "d", "g"]

# Problem 26: Generate the combinations of K distinct objects chosen from the N elements of a list
class Array
	def combinations(n, sol = [])
		if self.size == n
			sol << self
		else
			self.each_with_index do |ele, idx|
				sol.concat (self[0...idx].concat(self[(idx+1)..-1]).combinations(n))
			end
		end
		sol.uniq
	end
end

# [1,2,3,4,5].combinations(3)
# => [[2, 3, 4], [2, 4, 3], [3, 2, 4], [3, 4, 2], [4, 3, 2], [4, 2, 3], [1, 3, 4], [1, 4, 3], [3, 1, 4], [3, 4, 1], [4, 3, 1], [4, 1, 3], [1, 2, 4], [1, 4, 2], [2, 1, 4], [2, 4, 1], [4, 2, 1], [4, 1, 2], [1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 2, 1], [3, 1, 2]]

# Problem 27: Group the elements of a set into disjoint subsets
class Array
	def grouped_subset(*sets)
		out = []
		if sets.empty?
			return self
		elsif sets.inject(&:+) != self.size
			raise "Sum of sets must equal length of size of array"
		else
			set = sets.shift

			self.combinations(set).each do |combination|
				combo = []
				a = self.dup
				combination.each do |e|
					a.delete(e)
				end

				combo << (combination.sort)

				if sets.size == 1
					combo << a.sort

					out << combo
				else
					combos = a.grouped_subset(*sets).map do |subset|
						combo + subset
					end

					out = out.concat(combos)

					# sort [[1,2],[3,4,5],[6,7]]
					# to [[1,2],[6,7],[3,4,5]]
					out = out.map do |combo|
							combo.sort do |x,y|
							if x.length == y.length
								x[0] <=> y[0]
							else
								x.length <=> y.length
							end
						end
					end
				end
			end
		end

		# Only get unique permutations of the grouped subset
		out.sort.uniq
	end
end

# [1,2,3,4,5,6,7].grouped_subset(2,3,2)
# [[[1, 2], [3, 4], [5, 6, 7]],[[1, 2], [3, 5], [4, 6, 7]],[[1, 2], [3, 6], [4, 5, 7]],[[1, 2], [3, 7], [4, 5, 6]], [[1, 2], [4, 5], [3, 6, 7]],[[1, 2], [4, 6], [3, 5, 7]],[[1, 2], [4, 7], [3, 5, 6]]...]

# Problem 28: Sort a list of list according to length of sublists
class Array
	def lsort
		sort_by {|x| x.length}
	end

	def lsort_freq
		count = {}
		self.each do |array|
			size = array.size.to_s
			if count[size].nil?
				count[size] = [array]
			else
				count[size] << array
			end
		end

		count = count.sort_by {|x,y| y.length}

		count.inject([]) {|a, group| group[1].each {|ele| a << ele}; a}
	end
end

# [['a','b','c'], ['d','e'], ['f','h','h'], ['d','e'], ['i','j','k','l'],['m','n'],['o']].lsort
# => [["o"], ["d", "e"], ["m", "n"], ["d", "e"], ["a", "b", "c"], ["f", "h", "h"], ["i", "j", "k", "l"]]

# [['a','b','c'], ['d','e'], ['f','h','h'], ['d','e'], ['i','j','k','l'],['m','n'],['o']].lsort_freq
# => [["o"], ["i", "j", "k", "l"], ["a", "b", "c"], ["f", "h", "h"], ["d", "e"], ["d", "e"], ["m", "n"]]

























