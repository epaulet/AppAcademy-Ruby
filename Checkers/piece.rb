class Piece
  attr_reader :color, :pos

  def initialize(color, pos, board, king_flag = false)
    @color = color
    @pos = pos
    @board = board
    @king = king_flag
  end

  def king?
    @king
  end

  def perform_slide(to)
    slides = possible_slides

    if slides.include?(to)
      @board.move_piece!(@pos, to)
      update_pos(to)
      promote if @board.promote_piece?(self)
      true
    else
      false
    end
  end

  def perform_jump(to)
    jumps = possible_jumps

    if jumps.include?(to)
      @board.move_piece!(@pos,to)
      @board.remove_captured(@pos, to)
      update_pos(to)
      promote if @board.promote_piece?(self)
      true
    else
      false
    end
  end

  def perform_moves(move_sequence)
    perform_moves!(move_sequence) if valid_move_seq?(move_sequence.dup)
  end

  def valid_move_seq?(move_sequence)
    begin
      new_board = @board.dup
      new_board.get_piece(@pos).perform_moves!(move_sequence)
      return true
    rescue => e
      puts "#{e.class}: #{e}"
    end

    false
  end

  def perform_moves!(move_sequence)
    first_move = move_sequence.first

    if possible_slides.include?(first_move)
      perform_slide(first_move)
      if move_sequence.length > 1
        raise InvalidMoveError.new("Cannot move multiple times in one turn!")
      end
    elsif possible_jumps.include?(first_move)
      move_sequence.each do |move|
        unless possible_jumps.include?(move)
          raise InvalidMoveError.new("Can only chain jump moves!")
        end
        perform_jump(move)
      end
    else
      raise InvalidMoveError.new("This move is not possible!")
    end
  end

  def possible_slides
    my_row, my_col = @pos
    slides = move_diffs.map { |(row, col)| [row + @pos[0], col + @pos[1]] }
    slides.select {|pos| @board.empty_space?(pos) }
  end

  def possible_jumps
    my_row, my_col = @pos
    jumps = move_diffs.map { |(row, col)| [(row * 2) + my_row, (col * 2) + my_col] }
    jumps.select {|pos| @board.empty_space?(pos) }
  end

  def promote
    @king = true
  end

  def update_pos(pos)
    @pos = pos
  end

  def move_diffs
    diffs = []

    if king?
      diffs = [[-1, -1], [-1, 1], [1, -1], [1, 1]]
    else
      diffs = @color == :black ? [[1, -1], [1, 1]] : [[-1, -1], [-1, 1]]
    end

    diffs
  end

  def to_s
    if king?
      @color == :black ? "⚉" : "⚇"
    else
      @color == :black ? "⚈" : "⚆"
    end
  end

  def dup(board)
    Piece.new(@color, @pos.dup, board, @king_flag)
  end
end

class InvalidMoveError < ArgumentError
end
