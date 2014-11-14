# Better Approach: Use a stack and test the new queen against existing queens

# Naive Approach: Visualize the problem as a 2D board and puts the queens on each available place.

```
ruby 90_naive.rb
1
 .  .  .  .  .  .  .  .
 .  .  .  .  .  .  .  .
 .  .  .  .  .  .  .  .
 .  .  .  1  .  .  .  .
 .  1  .  .  .  .  .  .
 .  .  .  .  1  .  .  .
 .  .  1  .  .  .  .  .
 1  .  .  .  .  .  .  .
2
 .  .  .  .  .  .  1  .
 .  .  .  1  .  .  .  .
 .  .  .  .  .  .  .  .
 .  .  .  .  .  .  .  1
 .  1  .  .  .  .  .  .
 .  .  .  .  1  .  .  .
 .  .  1  .  .  .  .  .
 1  .  .  .  .  .  .  .
3
...
10187
 .  .  .  .  .  .  .  1
 .  .  .  .  .  1  .  .
 .  .  .  1  .  .  .  .
 .  .  .  .  .  .  1  .
 .  .  .  .  1  .  .  .
 .  .  .  .  .  .  .  .
 .  .  .  .  .  .  .  .
 .  .  .  .  .  .  .  .
10188
 .  .  .  .  .  .  .  1
 .  .  .  .  1  .  .  .
 .  .  .  .  .  .  1  .
 .  .  .  1  .  .  .  .
 .  .  .  .  .  1  .  .
 .  .  .  .  .  .  .  .
 .  .  .  .  .  .  .  .
 .  .  .  .  .  .  .  .
Solutions found: 92
First solution:
 .  .  .  1  .  .  .  .
 .  1  .  .  .  .  .  .
 .  .  .  .  .  .  1  .
 .  .  1  .  .  .  .  .
 .  .  .  .  .  1  .  .
 .  .  .  .  .  .  .  1
 .  .  .  .  1  .  .  .
 1  .  .  .  .  .  .  .
Guesses 10188
```