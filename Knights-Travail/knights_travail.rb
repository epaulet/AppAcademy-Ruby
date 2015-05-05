require "./00_tree_node.rb"

class KnightPathFinder
  attr_reader :board

  def initialize(start_pos)
    @start_pos = PolyTreeNode.new(start_pos)
    @board = make_board
    @visited_positions = [start_pos]
    build_move_tree
  end

  def make_board
    board = []
    8.times do |x|
      8.times do |y|
        board << [x, y]
      end
    end
    board
  end

  def build_move_tree
    queue = [@start_pos]

    until queue.empty?
      current_pos = queue.shift
      moves = new_move_positions(current_pos.value)

      moves.each do |move|
        new_move = PolyTreeNode.new(move)
        current_pos.add_child(new_move)
        queue << new_move
      end
    end
  end

  def new_move_positions(pos)
    moves = valid_moves(pos)

    unvisited = moves.select do |dest|
      !@visited_positions.include?(dest)
    end

    @visited_positions += unvisited

    unvisited
  end

  def valid_moves(pos)
    x = pos[0]
    y = pos[1]

    @board.select do |dest|
      x2 = dest[0]
      y2 = dest[1]
      x_delta = (x - x2).abs
      y_delta = (y - y2).abs

      total_spaces = x_delta + y_delta
      shortest_distance = [x_delta, y_delta].min

      total_spaces == 3 && shortest_distance > 0
    end
  end

  def find_path(end_pos)
    dest = @start_pos.bfs(end_pos)
    dest.trace_path_back
  end
end


if __FILE__ == $PROGRAM_NAME
  kpr = KnightPathFinder.new([0, 0])

  # p kpr.board
  # p kpr.valid_moves([1, 1])
  # p kpr.valid_moves([4, 4])
  # p kpr.find_path([1, 2])
  # p kpr.trace_path_back
  p kpr.find_path([7, 6])
  p kpr.find_path([6, 2])
  # p dest.trace_path_back


end
