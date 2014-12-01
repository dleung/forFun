require 'pry'

class Board
	MOVES = [[1, 2], [1,-2], [2,1], [2,-1], [-1,2], [-1,-2], [-2, 1], [-2, -1]]

	def initialize(rows, cols, initial)
		@board = []
		rows.times.each do |row|
			nrow = Array.new(cols)
			cols.times.each do |col|
				nrow[col] = [row,col]
			end
			@board = @board + nrow
		end
	end

	def possible_moves(placement)
		possible_moves = MOVES.inject({}) do |h, move|
			target = [placement[0] + move[0], placement[1] + move[1]]
			next h unless @board.include?(target)

			available_moves = MOVES.inject([]) do |a, pmove|
				ptarget = [target[0] + pmove[0], target[1] + pmove[1]]
				if @board.include?(ptarget)
					a << ptarget
				end
				a
			end

			h[target] = available_moves
			h
		end
	end
end

b = Board.new(5,5,nil)
puts b.possible_moves([1,1]).inspect