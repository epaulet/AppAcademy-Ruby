class Tile
  attr_accessor :bomb
  attr_reader :neighbor_bombs, :revealed, :flagged

  def initialize
    @revealed = false
    @bomb = false
    @flagged = false
  end

  def set_values(board)
    @board = board
    @coords = find_self
    @neighbors = find_neighbors
    @neighbor_bombs = count_bombs
    @symbol = set_symbol
  end

  def set_symbol
    if @bomb
      return "B"
    elsif @neighbor_bombs > 0
      return @neighbor_bombs.to_s
    end

    "_"
  end

  def find_self
    x = 0
    y = 0

    @board.each_with_index do |row, x_coord|
      row.each_with_index do |tile, y_coord|
        if tile == self
          x = x_coord
          y = y_coord
        end
      end
    end

    [x, y]
  end

  def find_neighbors
    x = @coords[0]
    y = @coords[1]

    neighbors = []
    (x-1..x+1).each do |x_coord|
      next if x_coord > 8 || x_coord < 0
      (y-1..y+1).each do |y_coord|
        next if y_coord > 8 || y_coord < 0
        tile = @board[x_coord][y_coord]
        neighbors << tile unless tile == self
      end
    end

    neighbors
  end

  def find_adjacent_neighbors
    x = @coords[0]
    y = @coords[1]

    adjacent_neighbors = []
    (x-1..x+1).each do |x_coord|
      next if x_coord > 8 || x_coord < 0
      (y-1..y+1).each do |y_coord|
        next if y_coord > 8 || y_coord < 0
        tile = @board[x_coord][y_coord]
        adjacent_neighbors << tile if ((x - x_coord).abs + (y - y_coord).abs) == 1
      end
    end

    adjacent_neighbors
  end

  def count_bombs
    count = 0

    @neighbors.each do |neighbor|
      count +=1 if neighbor.bomb
    end

    count
  end

  def display_tile
    if @revealed
      print " #{@symbol} "
    elsif @flagged
      print " F "
    else
      print " * "
    end
  end

  def reveal
    @revealed = true

    adjacent_neighbors = find_adjacent_neighbors

    adjacent_neighbors.each do |neighbor|
      neighbor.reveal if neighbor.neighbor_bombs == 0 && !neighbor.revealed && !neighbor.bomb
    end
  end

  def flag
    @flagged = !@flagged
  end
end
