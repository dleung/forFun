class Array
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

[3,1,9,6,2,0].bubble_sort