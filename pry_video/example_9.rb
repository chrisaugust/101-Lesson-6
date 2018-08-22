# example_9.rb

=begin
Write a method that takes an array of integers and returns a 
new array containing only odd numbers which are less than or equal to 15, 
or multiples of 3
=end

require 'pry'

def select_nums(arr)
  new_arr = []
  arr.each do |num|
#    binding.pry
    new_arr << num if num.odd? && (num <= 15 || num % 3 == 0)
  end
  new_arr
end

p select_nums([1, 2, 5, 6, 9, 12, 15, 17, 19, 21]) == [1, 5, 9, 15, 21]
p select_nums([6, 12, 18]) == []
p select_nums([3, 5, 7, 11, 15, 21]) == [3, 5, 7, 11, 15, 21]
