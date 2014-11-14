package main

import (
	"container/list"
	"flag"
	"log"
)

func main() {
	num := flag.Int("num", 0, "Number to write all the primes for")
	flag.Parse()

	potentialPrimes := list.New()

	// Creates the linked list from 2..num
	for i := 2; i <= *num; i++ {
		potentialPrimes.PushBack(i)
	}

	// Walks through the entire linked list from smallest and remove any multiples of i, since
	// those will be composites.
	for i := potentialPrimes.Front(); i != nil; i = i.Next() {
		for j := potentialPrimes.Front(); j != nil; j = j.Next() {
			if i.Value != j.Value && j.Value.(int)%i.Value.(int) == 0 {
				k := j
				j = j.Prev() // Backstep one element in order to successfully remove the target element
				potentialPrimes.Remove(k)
			}
		}
	}

	// Make a results array to pretty-print the results
	results := make([]int, 0)
	for i := potentialPrimes.Front(); i != nil; i = i.Next() {
		results = append(results, i.Value.(int))
	}

	log.Println(results)

	log.Printf("Is Prime? %t\n", isPrime(*num, results))
}

// If the last element in the sorted prime numbers is the number in question, then the number is prime.
func isPrime(num int, primes []int) bool {
	return primes[len(primes)-1] == num
}
