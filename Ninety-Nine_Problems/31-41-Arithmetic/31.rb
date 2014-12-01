# Problem 31: Determine whether a given integer is prime
class Fixnum
	def isPrime
		(2..Math.sqrt(self).ceil).each do |i|
			return false if self % i == 0
		end
		return true
	end

	# Using Sieve of Eratosthenes
	def primes
	  a = 2.upto(self).to_a
	  a.each do |i|
	    a.each do |j|
	      if j % i == 0 && i != j
	        a.delete(j)
	      end
	    end
	  end
	  
	  a = [1] + a
	end

	def isPrimeSieve
		self.primes.include?(self)
	end
end
# 7.isPrimeSieve
# => true

# Problem 32: Determine the greatest common divisor of two possible integers
# Using Euclid's algorithm
def mygcd(i,j)
	if i == 1 || j == 1
		return 1
	elsif i > j
		mygcd(i-j, j)
	elsif i < j
		mygcd(i, j-i)
	else
		return i
	end
end
# mygcd(36, 63)
# 9

# Problem 33: Determine whether two positive integers are coprime
def coprime?(i,j)
	mygcd(i,j) == 1
end

# coprime?(35, 64)
# => 1

# Problem 34: Calculate Euler's totient function phi(m)
class Fixnum
	def totient
		count = 1
	  2.upto(self).each do |i|
	  	count += 1 if coprime?(i, self)
	  end

	  count
	end
end
# 10.totient
# => 4

# Problem 35: Determine the prime factors of a given positive integer
class Fixnum
	def prime_factors
		out = []
		if self == 1
			return out
		elsif self.isPrime
			return [self]
		else
			guess = 2
			loop do
				if guess > self
					raise "No solutions found!"
				elsif self % guess == 0
					out << guess
					out.concat((self / guess).prime_factors)
					break
				else
					guess += 1 # only include odd integers as guesses
				end
			end
		end

		out
	end
end

# 315.prime_factors
# => [3, 3, 5, 7]

# Problem 36:  Determine the prime factors of a given positive integer
# Construct a list containing the prime factors and their multiplicity
class Fixnum
	def prime_factor_multiplicity
		self.prime_factors.inject({}) do |hash, i|
			if hash[i].nil?
				hash[i] = 1
			else
				hash[i] += 1
			end
			hash
		end
	end
end
# 315.prime_factor_multiplicity
# => {3=>2, 5=>1, 7=>1}

# Problem 37: Calculate Euler's totient phi(m) (improved)
class Fixnum
	def totient_improved
		self.prime_factor_multiplicity.inject(1) do |ans, (p, m)|
			ans = ans * (p - 1) * (p ** (m - 1))
			ans
		end
	end
end
# 10.totient_improved 

# Problem 39: A list of prime numbers
class Range
	def primes
		self.end.primes.select {|i| i >= self.begin}
	end
end
# (7..31).primes
# => [7, 11, 13, 17, 19, 23, 29, 31]

# Problem 40: Goldbach's conjecture
class Fixnum
	def goldbach
		raise "Must be greater than 2" unless self >= 2
		primes = self.primes
		primes.each do |prime|
			diff = self - prime
			if primes.include?(diff)
				return [prime, diff]
			end
		end
	end
end
# 28.goldbach
# => [5, 23]

# Problem 41: A list of goldbach compositions
class Range
	def goldbach_compositions(min = 0)
		out = []

		start = self.begin
		start += 1 if self.begin.odd?
		(start..self.end).step(2).each do |ele|
			v1, v2 = ele.goldbach
			out << [v1,v2] if v1 >= min && v2 >= min
		end

		out
	end
end

# (1..2000).goldbach_compositions(50)
# => [[67, 1789], [61, 1867]]
