@solutions = []

def valid?(stack)
	stack[0..-2].reverse.each_with_index do |pos, idx|
		if (pos == stack[-1]) || (pos + idx + 1 == stack[-1]) || (pos - (idx + 1) == stack[-1]) || (stack[-1] + idx + 1 == pos)
			return false
		end
	end
end

def queens(stack)
	if !valid?(stack)
		return
	elsif stack.size == 8
		@solutions << stack
	else
		(1..8).each do |pos|
			queens(stack + [pos])
		end
	end
end

queens([])
puts "Solutions Found: #{@solutions.size}"
puts "Last solution: #{@solutions.last.inspect}"