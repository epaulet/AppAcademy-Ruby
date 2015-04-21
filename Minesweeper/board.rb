class Board
  attr_reader :tiles

  def initialize
    @tiles = generate_blank_tiles
    place_bombs
    inform_tiles
  end


  def generate_blank_tiles
    new_tiles = Array.new(9) { Array.new(9) }

    new_tiles.map do |row|
      row = row.map do |tile|
        Tile.new
      end
    end
  end

  def place_bombs
    bombs_placed = 0

    while bombs_placed < 3
      random_tile = @tiles.sample.sample
      unless random_tile.bomb
        random_tile.bomb = true
        bombs_placed += 1
      end
    end
  end

  def inform_tiles
    @tiles.each do |row|
      row.each do |tile|
        tile.set_values(@tiles)
      end
    end
  end

  def print_board
    puts "Current Board:"
    puts "   0  1  2  3  4  5  6  7  8"
    @tiles.each_with_index do |row, index|
      print "#{index} "
      row.each do |tile|
        tile.display_tile
      end
      puts ""
    end
  end

  def make_move(action, coords)
    tile = find_tile(coords)

    if action == :r
      tile.reveal
    elsif action == :f
      tile.flag
    end
  end

  def find_tile(coords)
    @tiles[coords[1]][coords[0]]
  end

  def bomb_revealed?
    all_tiles = @tiles.flatten

    all_tiles.each do |tile|
      return true if tile.bomb && tile.revealed
    end

    false
  end

  def won?
    all_bombs_flagged? && revealed_board?
  end

  def revealed_board?
    all_tiles = @tiles.flatten

    empty_tiles = all_tiles.select { |tile| !tile.bomb }

    empty_tiles.each do |tile|
      return false unless tile.revealed
    end

    true
  end

  def all_bombs_flagged?
    all_tiles = @tiles.flatten

    bomb_tiles = all_tiles.select { |tile| tile.bomb }

    bomb_tiles.each do |tile|
      return false unless tile.flagged
    end

    true
  end

  def reveal_bombs
    all_tiles = @tiles.flatten

    bomb_tiles = all_tiles.select { |tile| tile.bomb }

    bomb_tiles.each do |tile|
      tile.reveal
    end
  end
end
