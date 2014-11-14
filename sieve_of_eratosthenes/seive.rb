def primes(n)
  a = 2.upto(n).to_a
  a.each do |i|
    a.each do |j|
      if j % i == 0 && i != j
        a.delete(j)
      end
    end
  end
  
  a
end
 
def totient(n)
  primes(n).count
end
 
primes(100)
# => [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
 
totient(10)
# => 4