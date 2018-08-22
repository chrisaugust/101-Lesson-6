# example_11.rb

=begin
Write a method that takes as argument an array of integers
and returns a new array with the even integers doubled.
=end

require 'pry'
require 'pry-byebug'

def double_num(num)
  num * 2
end

def double_evens(arr)
  arr.map do |num|
    binding.pry
    new_num = num.even? ? double_num(num) : num
  end
end

p double_evens([1, 2, 3, 4, 5]) == [1, 4, 3, 8, 5]
