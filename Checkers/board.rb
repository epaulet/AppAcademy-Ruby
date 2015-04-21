class Board
  def initialize(blank_board = false)
    @spaces = Array.new(8) { Array.new(8) }
    populate_board! unless blank_board
  end

  def populate_board!
    (1..8).each do |row_num|
      (1..8).each do |col_num|
        if (row_num + col_num).even?
          pos = [row_num, col_num]
          set_piece(pos, Piece.new(:black, pos, self)) if row_num.between?(1, 3)
          set_piece(pos, Piece.new(:red, pos, self)) if row_num.between?(6, 8)
        end
      end
    end
  end

  def render
    puts "   a  b  c  d  e  f  g  h"
    @spaces.each_with_index do |row, row_num|
      row_string =  "#{row_num + 1} "
      row.each_with_index do |piece, col_num|
        if (row_num + col_num).odd?
          row_string += "   ".colorize(:background => :light_black)
        elsif piece.nil?
          row_string += "   ".colorize(:background => :light_red)
        else
          row_string += " #{piece.to_s} ".colorize(:background => :light_red)
        end
      end
      puts row_string
    end
    print "\n"
  end

  def move(move)
    from = move.first
    destinations = move.drop(1)

    piece = get_piece(from)
    piece.perform_moves(destinations)
  end

  def move_piece!(from, to)
    piece = get_piece(from)

    set_piece(from, nil)
    set_piece(to, piece)
  end

  def promote_piece?(piece)
    row = piece.pos[0]
    color = piece.color

    promotion_row = color == :black ? 8 : 1

    row == promotion_row
  end

  def remove_captured(from, to)
    y1, x1 = from
    y2, x2 = to

    y0 = (y1 + y2) / 2
    x0 = (x1 + x2) / 2

    set_piece([y0, x0], nil)
  end

  def empty_space?(pos)
    piece = get_piece(pos)
    piece.nil?
  end

  def [](row, col)
    @spaces[row - 1][col - 1]
  end

  def []=(row, col, value)
    @spaces[row - 1][col - 1] = value
  end

  def get_piece(pos)
    row, col = pos
    self[row, col]
  end

  def set_piece(pos, piece)
    row, col = pos
    self[row, col] = piece
  end

  def dup
    new_board = Board.new(true)

    @spaces.flatten.compact.each do |piece|
      row, col = piece.pos
      color = piece.color
      king_flag = piece.king?
      new_piece = piece.dup(new_board)
      new_board[row, col] = new_piece
    end

    new_board
  end

  def pieces_remaining?(color)
    @spaces.flatten.compact.each do |piece|
      return true if piece.color == color
    end

    false
  end
end
