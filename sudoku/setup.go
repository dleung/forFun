package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
	"strings"
)

func Setup() {
	squares = Cross(Rows, Cols)

	SetupUnitList()
	SetupUnits()
	SetupPeers()
}

func Cross(a, b string) (res []label) {
	for _, a_ := range strings.Split(a, "") {
		for _, b_ := range strings.Split(b, "") {
			res = append(res, label(fmt.Sprintf("%s%s", a_, b_)))
		}
	}
	return
}

func SetupUnitList() {
	unitList = make([][][]label, 3)
	unitList[0] = make([][]label, 9)
	unitList[1] = make([][]label, 9)
	unitList[2] = make([][]label, 9)
	for _, c := range Cols {
		for i, cross := range Cross(Rows, string(c)) {
			unitList[0][i] = append(unitList[0][i], label(cross))
		}
	}
	for _, r := range Rows {
		for i, cross := range Cross(string(r), Cols) {
			unitList[1][i] = append(unitList[1][i], label(cross))
		}
	}

	strs := []string{"ADG", "BEH", "CFI"}
	ints := []string{"036", "147", "258"}
	for _, s := range strs {
		for _, t := range ints {
			for i, cross := range Cross(s, t) {
				unitList[2][i] = append(unitList[2][i], label(cross))
			}
		}
	}
}

func SetupUnits() {
	units = make(map[label][][]label)
	for _, cross := range Cross(Rows, Cols) {
		unitVal := make([][]label, 3)

	RowsFind:
		for _, unitList0 := range unitList[0] {
			for _, element := range unitList0 {
				if element == cross {
					unitVal[0] = unitList0
					break RowsFind
				}
			}
		}

	ColsFind:
		for _, unitList1 := range unitList[1] {
			for _, element := range unitList1 {
				if element == cross {
					unitVal[1] = unitList1
					break ColsFind
				}
			}
		}

	QuadFind:
		for _, unitList2 := range unitList[2] {
			for _, element := range unitList2 {
				if element == cross {
					unitVal[2] = unitList2
					break QuadFind
				}
			}
		}

		units[cross] = unitVal
	}
}

func SetupPeers() {
	peers = make(map[label][]label)

	for key, unitArray := range units {
		tempSet := make(map[label]*struct{})

		for _, subUnit := range unitArray {
			for _, subSubUnit := range subUnit {
				tempSet[subSubUnit] = nil
			}
		}

		peers[key] = make([]label, 0)
		for peer, _ := range tempSet {
			if key != peer {
				peers[key] = append(peers[key], peer)
			}
		}
	}
}

// BoardSetups read from the input filename and creates
// an array of the sudoku board
func BoardSetups(fname string) (boardSetups []string) {
	boardSetups = make([]string, 0)

	file, err := os.Open(fname)
	defer file.Close()

	if err != nil {
		log.Fatalln(err)
	}

	reader := bufio.NewReader(file)
	for {
		line, err := reader.ReadString('\n')

		boardSetups = append(boardSetups, line)

		if err == io.EOF {
			break
		}
	}

	return
}
