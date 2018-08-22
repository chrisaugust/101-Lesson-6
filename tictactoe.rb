# tictactoe.rb

require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] +
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] +
                [[1, 5, 9], [3, 5, 7]]
=begin
1. start
2. display board
3. player marks a square
4. computer marks a square
5. display updated board
6. check for winner
  7. display winner
8. check for tie
  9. display tie
10. loop back to step #3 if no winner or tie
11. play again?
12. loop back to #2 if yes
13. goodbye
=end

# step 1
def welcome
  system("clear")
  puts "Welcome to Tic Tac Toe"
end

def goodbye
  puts "Thanks for playing Tic Tac Toe."
  puts "Have a nice day :)"
end

# step 2 (and step 5)
def display_board(brd)
  puts
  puts " #{brd[1]} | #{brd[2]} | #{brd[3]}  "
  puts "---+---+---"
  puts " #{brd[4]} | #{brd[5]} | #{brd[6]}  "
  puts "---+---+---"
  puts " #{brd[7]} | #{brd[8]} | #{brd[9]}  "
  puts
end

# initialize hash to represent state of board
def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

# helper method for move validation
def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

# step 3
def player_makes_move!(brd)
  square = ''
  loop do
    puts "Which square do you choose? #{empty_squares(brd).join(', ')}"
    square = gets.chomp.to_i
    if empty_squares(brd).include?(square)
      brd[square] = PLAYER_MARKER
      break
    else
      puts "Sorry, that's not a valid choice."
    end
  end
end

# step 4
def computer_makes_move!(brd)
  square = ''
  puts "Now the computer is deciding where to move..."
  sleep(1)
  loop do
    square = rand(9) + 1
    if board_full?(brd)
      break
    elsif empty_squares(brd).include?(square)
      brd[square] = COMPUTER_MARKER
      break
    end
  end
end

# step 6
def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return 'Player'
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return 'Computer'
    end
  end
  nil
end

def someone_won?(brd)
  !!detect_winner(brd)
end

# step 8
def board_full?(brd)
  empty_squares(brd).empty?
end

welcome
loop do
  board = initialize_board
  display_board(board)
  loop do
    player_makes_move!(board)
    display_board(board)
    break if someone_won?(board) || board_full?(board)
    computer_makes_move!(board)
    display_board(board)
    break if someone_won?(board) || board_full?(board)
  end

  if someone_won?(board)
    puts "#{detect_winner(board)} won!"
  else
    puts "It's a tie!"
  end
  puts "Play again? (y)es or (n)o"
  again = gets.chomp
  unless again == "y"
    break
  end
end
goodbye
