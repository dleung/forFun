# Problem 1.  Implement an algo to determine if a string has all unique characters
# What if you cannot use an additional data structure?

def unique_chars?(string)
  hash = {}
  string.each_char do |char|
    if hash[char].nil?
      hash[char] = true
    else
      return false
    end
  end
  true
end

# Problem 2.  Reverse a string
def reverse(string)
  string_array = string.split("")
  return if string_array.empty?

  reverse = [string_array.pop]

  reverse << reverse(string_array.join(""))
  reverse.join("")
end

# Problem 3.  Given 2 strings, decide if a string is a permutation of another
def permute_of?(string1, string2)
  str_array1 = string1.split("")
  str_array2 = string2.split("")

  str_array2, str_array1 = str_array1, str_array2 if str_array2.size > str_array1.size

  str_array1.each do |char|
    if str_array2.include?(char)
      str_array2.delete(char)
    else
      return false
    end
  end

  true
end

# Problem 4. Replace all spaces in a string with another char
def replace(string, char, replace_char)
  string = string.split("")
  sol = ""
  if string.empty?
    return sol
  else
    strchar = string.shift
    if char == strchar
      sol += replace_char
    else
      sol += strchar
    end
    sol += replace(string.join(""), char, replace_char)
  end 
    
  sol
end

# Problem 5.  Basic compression using count of characters
def basic_compression(string)
  string = string.split("")
  out = ""
  return out if string.empty?

  char = string.shift
  count = 1
  out += char

  while string[0] == char
    string.shift
    count += 1
  end

  out += count.to_s
  out += basic_compression(string.join(""))
  out
end

# Problem 6.  Given that an image is represented by an NxN matrix,
# rotate it by 90 degrees.
def rotate(image)
  # image is a 2 dimentional array like [[1,2,3],[4,5,6], [7,8,9]]
  array = []
  cols = image[0].size
  image.size.times do 
    array << Array.new(cols)
  end

  image.each_with_index do |rows_array, row|
    rows_array.each_with_index do |element, col|
      array[col][row] = element
    end
  end

  array
end

# Problem 7.  Write an algorithm such that if an element in a NxN matrix
# is zero, then set the entire row and entire column to be zero
def set_zero(matrix)
  array = []
  cols = matrix[0].size
  matrix.size.times do 
    array << Array.new(cols)
  end

  matrix.each_with_index do |rows_array, row_index|
    catch :outerrow do
      rows_array.each_with_index do |element, col_index|
        if element == 0
          0.upto(cols - 1) do |col|
            array[row_index][col] = 0
          end

          0.upto(cols - 1) do |row|
            array[row][col_index] = 0
          end
          throw :outerrow
        else
          if array[row_index][col_index] != 0
            array[row_index][col_index] = element
          end
        end
      end
    end
  end

  array
end

# Problem 8.  Write a method to see if a string is a rotation of another string
def is_rotate(str1, str2)
  str1 = str1.split("")
  str2 = str2.split("")

  is_rotate = false
  index1 = 0

  # finds all the indexes of occurrences
  index2arr = []
  str2.each_with_index do |ele, index|
    index2arr << index if ele == str1[index1]
  end

  index2arr.each do |index2|
    index1 = 0

    catch :next_index do
      until index1 == (str1.size - 1)
        if str2[index2] != str1[index1]
          throw :next_index
        else
          if str2[index2 + 1].nil?
            index2 = 0
          else
            index2 += 1
          end
          index1 += 1
        end
      end

      return true
    end
  end

  false
end

is_rotate("ilovebigmac", "bigmacilove")
