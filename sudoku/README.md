# Sudoku

Sudoku is a sudoku-solver written in Go.  It is inspired by Norvig's solution in python (http://norvig.com/sudoku.html).

It is broken down into several key parts:

1.  **SETUP** Sudoku board is an object representation as a map data structure.  Each cell has a label (eg A0, A1, A2) and has possible values 1-9.  Therefore, the board is a a map of the labels to its possible values.  At the beginning of the implementation, every single cell has '123456789' as possible values.  When the board is set up, if the value is known for a cell, then it sets the possible value to be that known value (eg A0 = 4). 
2.  **ELIMINATION ONE** Two elimination strategies are used:  the first elimination strategy is that if a cell value has only ONE possible value, then the other cells cannot contain this as a possible value and therefore the value may be eliminated from them.  For example, if A0 is 4, then 4 can be eliminated from its associated rows (A1 to A8), associated columns (B0 to I0), and associated quadrants (A1 A2 B0 B1 B2 C0 C1 C2).  The collection of these associated cells is called 'peers'.
3.  **ELIMINATION TWO** The second elimination strategy is that if for a given cell, its potential value is not found in any of its associated strategy, then we can safely set that cell's value to its potential value.  For example, if A0's potential values are '123' but 3 is not present in A1 to A8, we can assign 3 to A0's cell.  The collection of these strategies for each cell is called 'units', and include its horizontal, vertical, and quadrant cells.
4. Any elimination can propogate additional eliminations on its associated cells.
5.  **TESTING CONVERGENCE** If no possible eliminations can be performed for a full iteration where we walk through every single cell, then we can consider the board to be 'solved', or converged.
6.  **DEPTH-FIRST SEARCH** If the board is converged but it's not valid, meaning there is at least one cell with more than 2 possible values, then the imlementation will do a depth-first recursive search by eliminating one of the possible values for the cell with the smallest possible values and trying to solve that board.  Each tested elimination is considered to be a 'guess'.  For very easy puzzles, 'guesses' can be zero.
7.  **INVALID BOARDS** Because most of the boards only have one solution, if the guess is incorrect, then the board will converge to a non-valid state.  In this state, there will be at least one cell with zero possible values.  If this state is reached, we will know the guess is incorrect.
8.  **MULTIPLE SOLUTIONS** For boards with multiple solutions, which can result if the number of initially filled in squares is less than 8, this implementation finds the first successful solution.
9.  **EXAMPLES** The list of sudoku boards is taken from Norvig's website containing mainly 'hard' and 'very hard' puzzles in 'sudoku_boards.txt'

```bash
./sudoku
Board, Setup
---------------------
4 . . | . . . | 8 . 5
. 3 . | . . . | . . .
. . . | 7 . . | . . .
---------------------
. 2 . | . . . | . 6 .
. . . | . 8 . | 4 . .
. . . | . 1 . | . . .
---------------------
. . . | 6 . 3 | . 7 .
5 . . | 2 . . | . . .
1 . 4 | . . . | . . .
---------------------
Board: Solution
---------------------
4 1 7 | 3 6 9 | 8 2 5
6 3 2 | 1 5 8 | 9 4 7
9 5 8 | 7 2 4 | 3 1 6
---------------------
8 2 5 | 4 3 7 | 1 6 9
7 9 1 | 5 8 6 | 4 3 2
3 4 6 | 9 1 2 | 7 5 8
---------------------
2 8 9 | 6 4 3 | 5 7 1
5 7 3 | 2 9 1 | 6 8 4
1 6 4 | 8 7 5 | 2 9 3
---------------------
2014/11/10 10:22:45 Guesses taken:  304
2014/11/10 10:22:45 Took 0.1263 secs
2014/11/10 10:22:45 Solved:  1
-----------------------------------------------------------------------
...
...
...

Board, Setup
---------------------
. . . | . 7 . | . 2 .
8 . . | . . . | . . 6
. 1 . | 2 . 5 | . . .
---------------------
9 . 5 | 4 . . | . . 8
. . . | . . . | . . .
3 . . | . . 8 | 5 . 1
---------------------
. . . | 3 . 2 | . 8 .
4 . . | . . . | . . 9
. 7 . | . 6 . | . . .
---------------------
Board: Solution
---------------------
5 9 4 | 8 7 6 | 1 2 3
8 2 3 | 9 1 4 | 7 5 6
6 1 7 | 2 3 5 | 8 9 4
---------------------
9 6 5 | 4 2 1 | 3 7 8
7 8 1 | 6 5 3 | 9 4 2
3 4 2 | 7 9 8 | 5 6 1
---------------------
1 5 9 | 3 4 2 | 6 8 7
4 3 6 | 5 8 7 | 2 1 9
2 7 8 | 1 6 9 | 4 3 5
---------------------
2014/11/10 10:22:51 Guesses taken:  50
2014/11/10 10:22:51 Took 0.0251 secs
2014/11/10 10:22:51 Solved:  106
-----------------------------------------------------------------------
metrics: 10:22:51.093025 timer solve
metrics: 10:22:51.093029   count:             106
metrics: 10:22:51.093032   min:           1357397
metrics: 10:22:51.093034   max:         1234359323
metrics: 10:22:51.093038   mean:         58127933.56
metrics: 10:22:51.093041   stddev:      128522119.37
metrics: 10:22:51.093044   median:       26608475.00
metrics: 10:22:51.093047   75%:          59784304.00
metrics: 10:22:51.093050   95%:         217215711.90
metrics: 10:22:51.093052   99%:         1172215148.60
metrics: 10:22:51.093055   99.9%:       1234359323.00
metrics: 10:22:51.093058   1-min rate:         13.40
metrics: 10:22:51.102981   5-min rate:         13.40
metrics: 10:22:51.102990   15-min rate:        13.40
metrics: 10:22:51.102994   mean rate:          17.17

# Note: units of timer are in nanoseconds.  Therefore, the average time 
# to solve each puzzle of the 106 puzzles is .058 seconds

```