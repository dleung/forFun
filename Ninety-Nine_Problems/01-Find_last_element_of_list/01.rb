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