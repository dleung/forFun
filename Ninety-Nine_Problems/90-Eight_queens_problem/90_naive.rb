require 'pry'
# Board Setup:
# 8a 8b 8c 8d 8e 8f 8g 8h
# 7a 7b 7c 7d 7e 7f 7g 7h
# 6a 6b 6c 6d 6e 6f 6g 6h
# 5a 5b 5c 5d 5e 5f 5g 5h
# 4a 4b 4c 4d 4e 4f 4g 4h
# 3a 3b 3c 3d 3e 3f 3g 3h
# 2a 2b 2c 2d 2e 2f 2g 2h
# 1a 1b 1c 1d 1e 1f 1g 1h

# positions is an array of all the positions available
# POSITIONS = [[1, "a"], [1, "b"], [1, "c"], [1, "d"], [1, "e"], [1, "f"], [1, "g"], [2, "a"], [2, "b"], [2, "c"], [2, "d"], [2, "e"], [2, "f"], [2, "g"], [3, "a"], [3, "b"], [3, "c"], [3, "d"], [3, "e"], [3, "f"], [3, "g"], [4, "a"], [4, "b"], [4, "c"], [4, "d"], [4, "e"], [4, "f"], [4, "g"], [5, "a"], [5, "b"], [5, "c"], [5, "d"], [5, "e"], [5, "f"], [5, "g"], [6, "a"], [6, "b"], [6, "c"], [6, "d"], [6, "e"], [6, "f"], [6, "g"], [7, "a"], [7, "b"], [7, "c"], [7, "d"], [7, "e"], [7, "f"], [7, "g"], [8, "a"], [8, "b"], [8, "c"], [8, "d"], [8, "e"], [8, "f"], [8, "g"]]
POSITIONS =[]
(1..8).each do |row|
	('a'..'h').each do |col|
		POSITIONS << [row, col]
	end
end

# Generates the previous value of a string since there is no string#pred method.
# REVERSE_STRING_MAP = {"g"=>"f", "f"=>"e", "e"=>"d", "d"=>"c", "c"=>"b", "b"=>"a", "a"=>"z"}
REVERSE_STRINGS = ('a'..'h').to_a.reverse
REVERSE_STRING_MAP = {}
REVERSE_STRINGS.each_with_index do |string, index|
	if string == 'a'
		REVERSE_STRING_MAP[string] = 'z'
	else
		REVERSE_STRING_MAP[string] = REVERSE_STRINGS[index + 1]
	end
end

class Problem
	attr_accessor :solutions, :guesses 

	def initialize
		@guesses = 0
		@solutions = []
	end

	# Performs a depth-first recursive search to determine the largest number of queens on the board at once
	def solve(board, position)
		# only for first iteration that position is nil
		if !position.nil?
			board.add_queen_to_board(position)
		end

		# Sees if the board has 8 queens
		if board.converged?
			if board.num_queens == 8
				self.solutions << board
			end
			self.guesses += 1
			puts guesses

			board.view_board
			return board
		end

		# Iterate through the available positions to try to place new queens.
		board.free_positions.each do |new_position|
			# We only want to consider positions not considered before since we are going in order of the sorted list
			next if position && before?(new_position, position)

			new_board = Board.new
			new_board.board = board.board.dup

			solve(new_board, new_position)
		end
	end

	def before?(p1, p2)
		POSITIONS.index(p1) < POSITIONS.index(p2)
	end
end

class Board
	# @board is a hash of positions to its status.
	# status = 0 (unclaimed)
	# status = 1 (occupied by queen)
	# status = 2 (attacked by queen)
	attr_accessor :board

	def initialize(opts = {})
		setup_board if opts[:setup_board]
	end

	def setup_board
		self.board = POSITIONS.inject({}) do |h, position|
			h[position] = 0 
			h
		end
	end

	# Tries to add a queen to a position on the board.
	# It will be successful if the position is unoccupied and not under attack
	def add_queen_to_board(position)
		# Determine if the square is free
		if board[position] != 0
			return false
		end

		# If this square is free, put a queen on it
		board[position] = 1

		# Sets the moves available by the queen to be attacked
		Queen.moves(position).each do |attack_position|
			board[attack_position] = 2 if board[attack_position] == 0
		end

		return true
	end

	# Counts the number of queens on the board so far
	def num_queens
		board.nil? ? 0 : board.values.select {|a| a == 1}.count
	end

	# Calculates the remaining number of unoccupied positions
	def free_positions
		board.select {|position, value| value == 0}.keys
	end

	# Tests to see if there are any more solutions for the board
	def converged?
		new_board = Board.new
		new_board.board = board.dup
		new_board.free_positions.each do |position|
			if new_board.add_queen_to_board(position)
				return false
			end
		end

		return true
	end

	# Print the board to STDOUT
	# .  .  .  .  .  .  .  1
  # .  .  .  .  1  .  .  .
  # .  .  .  .  .  .  1  .
  # .  .  .  1  .  .  .  .
  # .  .  .  .  .  1  .  .
  # .  .  .  .  .  .  .  .
  # .  .  .  .  .  .  .  .
  # .  .  .  .  .  .  .  .
	def view_board
		(1..8).to_a.reverse.each do |row|
			str = ""
			('a'..'h').each do |col|
				if board[[row,col]] == 2
					str << " . "
				else
					str << " #{board[[row, col]].to_s} "	
				end
			end

			puts str
		end
	end
end

class Queen
	class << self
		# Calculate the set of moves the queen can attack for a given position.
		# eg Queen.moves([1,'a'])
		# => [[2, "b"], [3, "c"], [4, "d"], [5, "e"], [6, "f"], [7, "g"], [8, "h"], 
		# [0, "b"], [2, "a"], [3, "a"], [4, "a"], [5, "a"], [6, "a"], [7, "a"], [8, "a"], 
		# [1, "b"], [1, "c"], [1, "d"], [1, "e"], [1, "f"], [1, "g"], [1, "h"], [0, "a"]]
		def moves(position)
			@moves ||= {}
			if @moves[position] != nil
				return @moves[position]
			end

			orig_row = position[0]
			orig_col = position[1]

			strategies = ["NE", "NW", "SE", "SW", "N", "E", "S", "W"]

			moves = []
			strategies.each do |strategy|
				catch :strategy do
					row = position[0]
					col = position[1]

					loop do
						case strategy
						when "NE"
							row = row.next
							col = col.next
						when "NW"
							row = row.next
							col = REVERSE_STRING_MAP[col]
						when "SE"
							row = row.pred
							col = col.next
						when "SW"
							row = row.pred
							col = REVERSE_STRING_MAP[col]
						when "N"
							row = row.next
						when "E"
							col = col.next
						when "S"
							row = row.pred
						when "W"
							col = REVERSE_STRING_MAP[col]
						end


						new_position = [row, col]
						if !POSITIONS.include?(new_position)
							throw :strategy
						end

						moves << new_position
					end
				end
			end

			@moves[position] = moves
			@moves[position]
		end
	end
end

p = Problem.new
p.solve(Board.new(setup_board: true), nil)
puts "Solutions found: #{p.solutions.count}"
puts "First solution:"
p.solutions.first.view_board
puts "Guesses #{p.guesses}"