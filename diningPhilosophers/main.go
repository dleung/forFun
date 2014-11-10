package main

import (
	"fmt"
	"log"
	"math/rand"
	"sync"
	"time"
)

type Philosopher struct {
	leftHand  *Fork
	rightHand *Fork
	name      string
}

// The philosopher can hold on to the fork or put it back on the table (owner = nil)
type Fork struct {
	owner *Philosopher
}

var gsync sync.Mutex
var philosophers = make([]*Philosopher, 5)

// Sets up the table.  Seats the philosophers and assign each philosopher his left and right forks
func init() {
	fork1 := &Fork{}
	fork2 := &Fork{}
	fork3 := &Fork{}
	fork4 := &Fork{}
	fork5 := &Fork{}

	philosophers[0] = &Philosopher{
		leftHand:  fork1,
		rightHand: fork2,
		name:      "Kang",
	}
	philosophers[1] = &Philosopher{
		leftHand:  fork2,
		rightHand: fork3,
		name:      "Turing",
	}
	philosophers[2] = &Philosopher{
		leftHand:  fork3,
		rightHand: fork4,
		name:      "Descartes",
	}
	philosophers[3] = &Philosopher{
		leftHand:  fork4,
		rightHand: fork5,
		name:      "Kierkegaard",
	}
	philosophers[4] = &Philosopher{
		leftHand:  fork5,
		rightHand: fork1,
		name:      "Wittgenstein",
	}
}

func main() {
	wg := new(sync.WaitGroup)

	rand.Seed(time.Now().UTC().UnixNano())
	randints := rand.Perm(5)

	// Seats the philosopher in a random order
	for _, i := range randints {
		philosopher := philosophers[i]
		philosopher.execute()
		log.Println("Hungry Philosopher seated: ", philosopher.name)
		wg.Add(1)
	}

	wg.Wait()
}

// The Philosopher watches the table for both left and right forks to be free.
// He must ask the server (global mutex) to check if he can raise both hands.
func (p Philosopher) execute() {
	go func() {
		for {
			gsync.Lock()
			p.raiseBothHands()
			gsync.Unlock()
			p.eat()
		}
	}()
}

// The philosopher, if he can, eat from the table for X seconds.  After he finishes
// Eating, he lowers each fork one at a time.
func (p Philosopher) eat() {
	if p.canEat() {
		fmt.Printf("%s is eating now!\n", p.name)
		time.Sleep(3 * time.Second)
		p.leftHand.lower()
		log.Printf("%s left fork lowered", p.name)
		p.rightHand.lower()
		log.Printf("%s right fork lowered", p.name)
	}
}

// The philosopher can only eat if both forks belongs to him.  He cannot
// grab a fork from someone else or if the fork is on the table.
func (p Philosopher) canEat() bool {
	if p.leftHand.owner == nil || p.rightHand.owner == nil {
		return false
	}

	if *p.leftHand.owner != p || *p.rightHand.owner != p {
		return false
	}

	return true
}

// The philosopher tries to raise both hands only if both forks are free.
// If only one is free, the philosopher doesn't do anything.
func (p Philosopher) raiseBothHands() {
	if p.leftHand.owner != nil || p.rightHand.owner != nil {
		return
	}

	p.leftHand.raise(&p)
	p.rightHand.raise(&p)

	log.Printf("%s both forks raised", p.name)
}

// Raise one of the philosopher's forks so he can eat
func (f *Fork) raise(p *Philosopher) {
	f.owner = p
}

// Lower one of the philosopher's forks back to the table
func (f *Fork) lower() {
	f.owner = nil
}
