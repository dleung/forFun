# Dining Philosopher's Solution in Go

Dining Philosopher's is a popular concurrent algorithm design to illustrate synchronization issues (http://en.wikipedia.org/wiki/Dining_philosophers_problem).  

**Problem Statement**

Given 5 philosophers and 5 forks at the table, each philosopher wants to eat the plate of spaghetti using a fork on his left AND right hand.  The philosopher can only eat when he has both forks.  After he has eaten, which takes a finite number of time, he will put down the fork on each hand back to the table.  

If a fork is on the table, then any of the philosopher that the fork is assigned to can grab the table.

The problem is that if this runs, it will quickly reach into a state of deadlock, where all philosophers is unable to raise both forks and no one is eating.

**Implementation**
1.  **TABLE SETUP** There are five philosophers and five forks.  Each philosopher is assigned two forks, one on his left hand and one on his right hand.  Each fork can belong to one philosopher at a time, which is when the philosopher picks up the fork.  During the initial phase, the fork isn't picked up and therefore unassigned to a philosopher.
2.  I used the strategy where in order to keep at least 2 philosophers eating (the max number of philosophers eating at any time), each philosopher must see that BOTH forks are available before picking them up.  If only a single fork is available, the philosopher wait and continually to "think".
3.  My implementation uses global mutex that each philosopher must request in order to request the forks.  This is because if a philosopher sees two forks available, he will try to pick each one one at a time.  However, after he picks up a fork, it is possible that another philosopher will pick up the other fork first.  Therefore, this mutex allows only one philosopher to look at the forks at a time, preventing this race condition.

```
>> ./diningPhilosophers
2014/11/05 19:35:30 Philosopher created:  Turing
2014/11/05 19:35:30 Philosopher created:  Wittgenstein
2014/11/05 19:35:30 Philosopher created:  Descartes
2014/11/05 19:35:30 Philosopher created:  Kierkegaard
2014/11/05 19:35:30 Philosopher created:  Kang
2014/11/05 19:35:30 Turing both forks raised
Turing is eating now!
2014/11/05 19:35:30 Wittgenstein both forks raised
Wittgenstein is eating now!
2014/11/05 19:35:33 Turing left fork lowered
2014/11/05 19:35:33 Turing right fork lowered
2014/11/05 19:35:33 Wittgenstein left fork lowered
2014/11/05 19:35:33 Wittgenstein right fork lowered
2014/11/05 19:35:33 Kang both forks raised
Kang is eating now!
2014/11/05 19:35:33 Kierkegaard both forks raised
Kierkegaard is eating now!
2014/11/05 19:35:36 Kang left fork lowered
2014/11/05 19:35:36 Kang right fork lowered
2014/11/05 19:35:36 Kierkegaard left fork lowered
2014/11/05 19:35:36 Kierkegaard right fork lowered
2014/11/05 19:35:36 Turing both forks raised
Turing is eating now!
2014/11/05 19:35:36 Wittgenstein both forks raised
Wittgenstein is eating now!
2014/11/05 19:35:39 Turing left fork lowered
2014/11/05 19:35:39 Turing right fork lowered
2014/11/05 19:35:39 Wittgenstein left fork lowered
2014/11/05 19:35:39 Wittgenstein right fork lowered
2014/11/05 19:35:39 Kierkegaard both forks raised
Kierkegaard is eating now!
2014/11/05 19:35:39 Kang both forks raised
Kang is eating now!
... (loops forever)
```