# tictactoe.rb

require 'pry'

INITIAL_MARKER = ' '
PLAYER_MARKER = 'X'
COMPUTER_MARKER = 'O'
# valid options for PLAYS_FIRST are "computer", "player", and "choose"
PLAYS_FIRST = "choose"
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

def choose
  loop do
    puts "(C)omputer or (P)layer to make first move?"
    choice = gets.chomp.downcase
    if choice == 'c' || choice == 'computer'
      return 'computer'
    elsif choice == 'p' || choice == 'player'
      return 'player'
    else
      puts "Not a valid choice."
    end
  end
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

# helper methods for computer defense

def imminent_threat?(brd)
  !!detect_threat(brd, PLAYER_MARKER)
end

# helper method for computer offense

def possible_win?(brd)
  !!detect_threat(brd, COMPUTER_MARKER)
end

# detects threats of 2 squares in a row
# returns an array with the winning line that needs to be defended against, or nil
# can be used defensively and offensively by changing value of player param

def detect_threat(brd, marker)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(marker) == 2 && brd.values_at(*line).count(INITIAL_MARKER) == 1
      return line
    end
  end
  nil
end

# joinor method
# takes an array and optionally a delimiting char and final connecting conjunction
# these optional params default to comma and 'or' respectively
# returns a string with the array elements joined with delimiter and conjunction

def joinor(arr, dlmtr=', ', conj='or')
  case arr.size
  when 0 then ''
  when 1 then arr.first
  when 2 then arr.join(" " + conj + " ")
  else
    final_element = arr.pop
    arr.push(conj)
    arr = arr.join(dlmtr) + ' ' + final_element.to_s
  end
end

# step 3
def player_makes_move!(brd)
  square = ''
  loop do
    puts "Which square do you choose? Options are: #{joinor(empty_squares(brd), ', ', 'and')}"
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
  puts "The computer is deciding where to move..."
  sleep(1)
  if possible_win?(brd)
    detect_threat(brd, COMPUTER_MARKER).each do |sqr|
      if empty_squares(brd).include?(sqr)
        brd[sqr] = COMPUTER_MARKER
        break
      end
    end
  elsif imminent_threat?(brd)
    detect_threat(brd, PLAYER_MARKER).each do |sqr|
      if empty_squares(brd).include?(sqr)
        brd[sqr] = COMPUTER_MARKER
        break
      end
    end
  # play center square
  elsif empty_squares(brd).include?(5)
    brd[5] = COMPUTER_MARKER
  else
    square = empty_squares(brd).sample
    brd[square] = COMPUTER_MARKER
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

def alternate_player(current_player)
  if current_player == 'computer'
    'player'
  else
    'computer'
  end
end

def place_piece!(brd, player)
  if player == 'computer'
    computer_makes_move!(brd)
  elsif player == 'player'
    player_makes_move!(brd)
  else
    puts "Something malfunctioned!"
  end
end

welcome
loop do
  player_wins = 0
  computer_wins = 0
  loop do
    board = initialize_board
    if PLAYS_FIRST == 'choose'
      current_player = choose
    else
      current_player = PLAYS_FIRST
    end
    loop do
      display_board(board)
      place_piece!(board, current_player)
      current_player = alternate_player(current_player)
      break if someone_won?(board) || board_full?(board)
    end

    winner = ''
    if someone_won?(board)
      winner = detect_winner(board)
      puts "#{winner} won!"
      case winner
      when 'Player'
        player_wins += 1
      when 'Computer'
        computer_wins += 1
      end
    else
      puts "It's a tie!"
    end
    puts "The score is Player: #{player_wins}, Computer: #{computer_wins}" 
    if player_wins == 5 || computer_wins == 5
      puts "-------------------------------"
      puts "That makes 5 wins for #{winner}"
      break 
    else
      puts "Play again? (y)es or (n)o"
      again = gets.chomp
      if again == "n"
        goodbye
        exit(0)
      elsif again == "y"
        next
      end
    end
  end
  puts "Play another best of 5? (y) or (n)o"
  another_five = gets.chomp
  unless another_five == "y"
    break
  end
end
goodbye
