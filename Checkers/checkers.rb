require_relative 'board'
require_relative 'piece'
require_relative 'players'
require 'colorize'

class Game
  def initialize(p1 = HumanPlayer.new, p2 = HumanPlayer.new)
    @board = Board.new
    @players = {
      :black => p1,
      :red => p2
    }
    p1.assign_color(:black)
    p2.assign_color(:red)

    @turn = :black
  end

  def play_game
    welcome_message

    while @board.pieces_remaining?(:red) && @board.pieces_remaining?(:black)
      @board.render
      puts "#{@turn.to_s.capitalize}'s turn!'"
      move = @players[@turn].get_move(@board.dup)
      @board.move(move)
      @board.render
      switch_turn
    end

  end

  def welcome_message
    puts "Welcome to checkers!"
    puts "Please format your moves in the following manner:"
    puts "'g2 f3', 'b2 d4 f6', etc."
  end

  def switch_turn
    @turn = @turn == :black ? :red : :black
  end
end



if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play_game
end
