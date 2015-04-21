class HumanPlayer
  COLS = ('a'..'h').to_a
  def assign_color(color)
    @color = color
  end

  def get_move(board)
    puts "Input starting coordinates and all jumps with spaces in between:"
    print "> "
    input = gets.chomp
    coords = input.split
    move_sequence = []

    coords.each do |coord|
      col = COLS.index(coord[0]) + 1
      row = coord[1].to_i
      move_sequence << [row, col]
    end

    move_sequence
  end
end
