require './tile.rb'
require './board.rb'
require 'yaml'

class Game
  def initialize(game_save = nil)
    @board = Board.new
  end

  def play
    welcome_message

    until @board.bomb_revealed? || @board.won?
      input = player_input

      if input == "q"
        quit
        return nil
      end

      action, coords = parse(input)
      @board.make_move(action, coords)
    end

    if @board.all_bombs_flagged?
      @board.print_board
      puts "YOU WIN!"
    else
      @board.reveal_bombs
      @board.print_board
      puts "YOU LOSE!"
    end

  end

  def quit
    puts "Enter name of game: "
    file_name = gets.chomp + ".yml"

    File.write(file_name, YAML.dump(self))
  end

  def welcome_message
    puts "Welcome to MineSweeper!"
    puts "'f<x><y>' flags tile."
    puts "'r<x><y>' reveals tile."
    puts "Good luck!\n\n"
    puts "To quit, enter 'q'"
  end

  def player_input
    @board.print_board

    print "Enter your move: "

    gets.chomp
  end

  def parse(input)
    action = input[0].to_sym
    x = input[1].to_i
    y = input[2].to_i

    [action, [x, y]]
  end

  def self.load(file_name)
    YAML.load_file(file_name)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play

  game2 = Game.load("test.yml")
  game2.play
end
