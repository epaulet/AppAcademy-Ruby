require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def losing_node?(evaluator)
    opposite_eval = evaluator == :x ? :o : :x

    if @board.winner == opposite_eval
      true
    elsif @board.winner == evaluator || board.tied?
      false
    else
      results = []

      children.each do |child|
        if child.losing_node?(evaluator)
          results << true
        else
          results << false
        end
      end

      
    end
  end

  def winning_node?(evaluator)
    # if @board.winner == evaluator
    #   return true
    # else
    #   children.each do |child|
    #     child.winning_node?(evaluator)
    #   end
    # end
    #
    # false
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    children_array = []

    3.times do |row_number|
      3.times do |column_number|
        new_pos = [row_number, column_number]

        if @board.empty?(new_pos)
          new_board = @board.dup
          new_board.[]=(new_pos, @next_mover_mark)
          new_child = TicTacToeNode.new(new_board, next_mark, new_pos)
          children_array << new_child
        end
      end
    end

    children_array
  end

  def next_mark
    @next_mover_mark == :x ? next_mover_mark = :o : next_mover_mark = :x
    next_mover_mark
  end
end
