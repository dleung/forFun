package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"strings"
	"time"

	"github.com/rcrowley/go-metrics"
)

const (
	Cols           = "012345678"
	Rows           = "ABCDEFGHI"
	PossibleValues = "123456789"
)

// Board cell labels.  Each cell label has a value (1..9)
// A0 A1 A2 | A3 A4 A5 | A6 A7 A8
// B0 B1 B2 | B3 B4 B5 | B6 B7 B8
// C0 C1 C2 | C3 C4 C5 | C6 C7 C8
// ------------------------------
// D0 D1 D2 | D3 D4 D5 | D6 D7 D8
// E0 E1 E2 | E3 E4 E5 | E6 E7 E8
// F0 F1 F2 | F3 F4 F5 | F6 F7 F8
// ------------------------------
// G0 G1 G2 | G3 G4 G5 | G6 G7 G8
// H0 H1 H2 | H3 H4 H5 | H6 H7 H8
// I0 I1 I2 | I3 I4 I5 | I6 I7 I8

// sudokuBoard is a map of the cell labels to the possible values of the board
// {"A1" => "123", "A2" => "123", ...}
type sudokuBoard struct {
	cells map[label]*values
}

// label is a single cell label on the board.
// "A1"
type label string

// values is a string containing possible values of the labeled cell.  Always starts as '123456789'
type values string

// squares contains the possible labels of the sudokuBoard
// [A0 A1 A2 A3 A4 A5 A6 A7 A8 ... H4 H5 H6 H7 H8 I0 I1 I2 I3 I4 I5 I6 I7 I8]
var squares []label

// unitList contains all the possible label combinations that a cell belongs to
// [[[A0 A1 A2 A3 A4 A5 A6 A7 A8] ... [G6 G7 G8 H6 H7 H8 I6 I7 I8]]]
var unitList [][][]label

// units is a map of the label to its units.  A cell has exactly 3 unit lists, one for
// horizontal, vertical, and quadrant.
// map[D7:[[D0 D1 D2 D3 D4 D5 D6 D7 D8] [A7 B7 C7 D7 E7 F7 G7 H7 I7] [D6 D7 D8 E6 E7 E8 F6 F7 F8]] ... F6:[[F0 F1 F2 F3 F4 F5 F6 F7 F8] [A6 B6 C6 D6 E6 F6 G6 H6 I6] [D6 D7 D8 E6 E7 E8 F6 F7 F8]]]
var units map[label][][]label

// Peers is a map of a flattened array of the cell to its unique units.
// map[F6:[H6 I6 D8 E7 F1 F4 C6 F3 F7 A6 F5 B6 D6 E6 G6 D7 E8 F0 F2 F8] ... I4:[B4 C4 G3 H5 I5 I7 G5 A4 E4 G4 I0 I8 I3 I6 D4 F4 H4 H3 I1 I2]]
var peers map[label][]label

// For every guess the algorithm has to take, increment this by one.
// Harder puzzles have more guesses
var guesses int

// solved is the global number of solved sudoku puzzles
var solved int

// 'sudoku_boards.txt'

func init() {
	Setup()
}

func main() {
	var fname string
	flag.StringVar(&fname, "file", "sudoku_boards.txt", "path to the list of sudoku to solve")
	flag.Parse()

	boardSetups := BoardSetups(fname)

	// Veasy sudoku
	// boardSetup1 := "9.3.8.26..7..34..1.182.7.34.958.6.4.4.7..96.8..24.31.572..1..596..39.4.235.74.8.."

	// Hard sudoku
	// boardSetup2 := "6.....8.3.4.7.................5.4.7.3..2.....1.6.......2.....5.....8.6......1...."

	// Apparently, world's hardest sudoku (http://www.telegraph.co.uk/science/science-news/9359579/Worlds-hardest-sudoku-can-you-crack-it.html)
	// boardSetup3 := "8..........36......7..9.2...5...7.......457.....1...3...1....68..85...1..9....4.."
	// boardSetups = []string{boardSetup1, boardSetup2, boardSetup3}

	t := metrics.NewTimer()
	metrics.Register("solve", t)

	for _, boardSetup := range boardSetups {
		board := ParseBoard(boardSetup)
		fmt.Println("Board, Setup")
		board.ViewBoard(false)

		t.Time(func() {
			startTime := time.Now()
			guesses = 0
			board.Solve()
			solved++
			fmt.Println("Board: Solution")
			board.ViewBoard(false)
			log.Println("Guesses taken: ", guesses)
			log.Printf("Took %0.4f secs", time.Since(startTime).Seconds())
			log.Println("Solved: ", solved)
			fmt.Println(strings.Repeat("-", 100))
		})

	}

	go func() {
		metrics.Log(metrics.DefaultRegistry, 90e9, log.New(os.Stdout, "metrics: ", log.Lmicroseconds))
	}()
	time.Sleep(1 * time.Second)
}

// Solve tries to solve a board.  If EliminateAll failes for each iteration, meaning
// there is at least one square with more than 1 possible values, then
// Solve will perform a recursive depth-first search on the SMALLEST possible values
// string greater than 1.
func (b *sudokuBoard) Solve() (solved bool) {
	b.EliminateAll()

	if b.isSolved() {
		if b.isValid() {
			// If a board is both solved and valid, then we have an answer!
			return true
		} else {
			return false
		}
	} else {
		smallestLabel, smallestValues := b.findSmallestCell()

		for _, value := range strings.Split(string(*smallestValues), "") {
			// Guess the next iteration of the solver by removing one
			// possible value from the cell and tries to solve the board.
			newVal := values(strings.Replace(smallestValues.toStr(), value, "", -1))

			newBoard := b.Clone()

			newBoard.cells[smallestLabel] = &newVal

			solved := newBoard.Solve()
			guesses++

			if solved {
				for _, key := range squares {
					// If the board is solved, replace the existing
					// board with the solution
					b.cells[key] = newBoard.cells[key]
				}
				return true
			}
		}
	}

	return false
}

// EliminateAll loops every cell and tries to
// eliminate any possible values of that cell.  If it completes
// a full iteration where no possible values is eliminated,
// then the loop terminates.
func (b *sudokuBoard) EliminateAll() {
eliminateAll:
	for _, key := range squares {
		var eliminated = false
		for _, col := range b.cells[key].toArray() {
			if b.Eliminate(label(key), col) {
				if !b.isValid() {
					break
				}
				eliminated = true
			}
		}
		if eliminated {
			continue eliminateAll
		}
	}
}

// Eliminate takes in a label eg. F6 and tries to eliminate a value from that cell.
// For example, if F6 has possible values '123456' and value '1' is tested, Eliminate
// tests the peer cells if it is possible.
func (b *sudokuBoard) Eliminate(lab label, val string) bool {
	eliminated := b.EliminateAsSingle(lab, val)

	eliminated2 := b.EliminateAsUnique(lab, val)

	return eliminated || eliminated2
}

// EliminateAsSingle checks to see if the label cell has a single value.  If this is true,
// remove the value from all the peer cells.
func (b *sudokuBoard) EliminateAsSingle(lab label, val string) (eliminated bool) {
	cellVals := b.cells[lab]

	// if the cell values contain more than 1 possible value or if it's a single value
	// but not equal to the tested value, then it doesn't qualify to be eliminated.
	if len(*cellVals) != 1 || *cellVals != values(val) {
		return
	}

	cellPeers, _ := peers[lab]

	for _, peerLabel := range cellPeers {
		// Skip the cell if the label is equal to itself
		if peerLabel == lab {
			continue
		}

		peerVal := b.cells[peerLabel].toStr()

		// if the peer's values doesn't contain the tested value, skip it.
		if !strings.Contains(peerVal, val) {
			continue
		}

		//log.Printf("Elimination detected: Removing %s from %s\n", val, peerLabel)
		newPeerVal := values(strings.Replace(peerVal, val, "", 1))

		b.cells[peerLabel] = &newPeerVal

		// If the result of the replacement reduces the possible values of
		// the peer to 1, then propogate EliminateAsSingle for that label as well.
		if len(newPeerVal) == 1 {
			b.EliminateAsSingle(peerLabel, string(newPeerVal))
		}

		eliminated = true
	}

	return eliminated
}

// EliminateAsNotUnique checks to see of any units contains the value.  If it is not found
// Then assigns the value to this label.  For example, if the A row only has 3 as a possible
// value in A3, then replace the possible value of A3 to be 3
func (b *sudokuBoard) EliminateAsUnique(lab label, val string) (eliminated bool) {
	fVal := b.cells[lab]

	if len(*fVal) <= 1 {
		return false
	}

	// strategy = ["A1", "A2", "A3"]...["A1","B1"]
	// For each strategy, test the uniqueness separately.  This is because
	// 9 may appear in a row but not the column strategy, so that means
	// 9 will qualify for elimination based on column strategy
	for _, strategy := range units[lab] {
		eliminated = true

		// labs = "A1".."A2"
	Search:
		for _, labs := range strategy {
			// ignore if cell is itself
			if labs == lab {
				continue
			}

			// performs a search on all cells for that strategy.  If
			// the value is found, then the elimination failed.  Otherwise
			// the value qualifies for elimination, and we can set that cell's
			// values to be the single value.
			for _, unitVal := range b.cells[labs].toArray() {
				if unitVal == val {
					eliminated = false
					break Search
				}
			}
		}

		if eliminated {
			newPeerVal := values(val)
			//log.Printf("Setting label %s to %s", lab, newPeerVal)
			b.cells[lab] = &newPeerVal

			b.EliminateAsSingle(lab, string(newPeerVal))

			return eliminated
		}
	}

	return eliminated
}

// ParseBoard takes a string and returns a sudokuBoard containing
// a map of all the cell's keys and possible values
func ParseBoard(setup string) *sudokuBoard {
	board := &sudokuBoard{
		cells: make(map[label]*values),
	}

	cell := 0
	for _, rows := range strings.Split(Rows, "") {
		for _, col := range strings.Split(Cols, "") {
			var possibleValues values
			if string(setup[cell]) == "." {
				possibleValues = values("123456789")
			} else {
				possibleValues = values(setup[cell])
			}

			board.cells[label(rows+col)] = &possibleValues
			cell++
		}
	}

	return board
}

// ViewBoard prints out the board in a friendly format.
// if showPossibilities is true, then it lists out all the possible
// values for each unsolved cell.  If false, then it replaces it with
// a '.'
func (b *sudokuBoard) ViewBoard(showPossibilies bool) {
	rows := strings.Split(Rows, "")

	fmt.Println(strings.Repeat("-", 21))
	for i := 0; i < 11; i++ {
		var rowKey string

		if i >= 0 && i <= 2 {
			rowKey = rows[i]
		} else if i >= 4 && i <= 6 {
			rowKey = rows[i-1]
		} else if i >= 8 && i <= 10 {
			rowKey = rows[i-2]
		} else {
			fmt.Println(strings.Repeat("-", 21))
			continue
		}

		var row []string

		j := 0
		for j <= 8 {
			for k := 0; k < 3; k++ {
				val := b.cells[label(fmt.Sprintf("%s%d", rowKey, j))]
				if !showPossibilies && len(*val) != 1 {
					zeroVal := values(".")
					val = &zeroVal
				}
				row = append(row, string(*val))

				j++
			}

			if j != 9 {
				row = append(row, "|")
			}
		}

		if showPossibilies {
			newRow := make([]string, 0)
			for _, r := range row {
				newRow = append(newRow, fmt.Sprintf("%9s", r))
			}

			fmt.Println(strings.Join(newRow, " "))
		} else {
			fmt.Println(strings.Join(row, " "))
		}
	}
	fmt.Println(strings.Repeat("-", 21))
}

// The board is considered 'solved' if any cells have at most
// one value. Note that a board is considered solved (reached convergence)
// with zero possible values for several cells.
func (b *sudokuBoard) isSolved() (solved bool) {
	solved = true
	for _, lab := range squares {
		if len(*b.cells[lab]) != 1 {
			solved = false
			break
		}
	}
	return
}

// isValid checks to see if the board is illegal and any cells have zero
// possible values
func (b *sudokuBoard) isValid() bool {
	for _, lab := range squares {
		values := b.cells[lab]
		if values == nil {
			return false
		}
	}
	return true
}

// Clones a sudokuBoard to a new sudokuBoard object
func (b *sudokuBoard) Clone() *sudokuBoard {
	newBoard := &sudokuBoard{
		cells: make(map[label]*values),
	}
	for _, lab := range squares {
		newBoard.cells[lab] = b.cells[lab]
	}

	return newBoard
}

// For a board, find the cell with the smallest possible values
func (b *sudokuBoard) findSmallestCell() (label, *values) {
	var smallestLabel label
	var smallestLength int = 1000

	for _, lab := range squares {
		values := b.cells[lab]
		if len(*values) != 1 && len(*values) < smallestLength {
			smallestLabel = lab
			smallestLength = len(*values)
		}
	}

	return smallestLabel, b.cells[smallestLabel]
}

func (val *values) toStr() string {
	return string(*val)
}

func (val *values) toArray() []string {
	return strings.Split(string(*val), "")
}
