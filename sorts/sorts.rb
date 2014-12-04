class Array
	def qsort
		a = self.dup
		a.partition!(0, a.size - 1)
		a
	end

	# This implementation assumes pivot is always last element
	def partition!(i, j)
		return if j - i <= 0

		index = 0
		0.upto(j-1) do |i|
			if self[i] < self[j]
				self[i], self[index] = self[index], self[i]
				index += 1
			end
		end	

		self[j], self[index] = self[index], self[j]

		self.partition!(i, index - 1)
		self.partition!(index+1, j)
	end

	def insertion_sort
		a = self.dup
		a.each_with_index do |ele, indx|
			while indx != 0 && ele < a[indx - 1] do
				a[indx] = a[indx - 1]
				a[indx - 1] = ele
				indx -= 1
			end
		end
		a
	end

	def bubble_sort
		a = self.dup
		changed = true
		until changed == false do
			changed = false
			a.each_with_index do |ele, indx|
				next if indx == 0

				if ele < a[indx - 1]
					a[indx] = a[indx - 1]
					a[indx - 1] = ele
					changed = true
				end
			end
		end
		a
	end
end

class Heap
	def initialize(array)
		@array = array
		build_heap!
	end

	def left(index)
		index * 2
	end

	def right(index)
		index * 2 + 1
	end

	def heapify!(i, heap_size)
		l = left(i + 1) - 1
		r = right(i + 1) - 1

		largest = if l < heap_size && @array[l] > @array[i]
			l
		else
			i
		end

		if r < heap_size && @array[r] > @array[largest]
			largest = r
		end

		if largest != i
			@array[largest], @array[i] = @array[i], @array[largest]

			@array = heapify(largest, heap_size)
		end

		@array
	end

	def build_heap!
		(0..(@array.size/2)).each do |i|
			heapify(i, @array.size)
		end

		@array
	end

	def heapsort
		heapsize = @array.size

		until heapsize == 1
			@array[0], @array[heapsize-1] = @array[heapsize-1], @array[0]
			heapsize -= 1
			heapify!(0, heapsize)
		end

		@array
	end
end
# heap = Heap.new([16, 4, 10, 14, 7, 9, 3, 2, 8, 1]).heapsort
# => [1, 2, 3, 4, 7, 8, 9, 10, 14, 16]
