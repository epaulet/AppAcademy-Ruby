class PolyTreeNode
  attr_reader :children, :value, :parent

  def initialize(value)
    @parent = nil
    @children = []
    @value = value
  end

  def parent=(parent)
    @parent.children.delete(self) unless @parent.nil?
    @parent = parent
    @parent.children << self unless @parent.nil? || @parent.children.include?(self)
  end

  def add_child(child)
    child.parent = self
  end

  def remove_child(child)
    raise "Error: node is not a child." if child.parent.nil?
    child.parent = nil
  end

  def dfs(target_value)
    if @value == target_value
      return self
    else
      @children.each do |child|
        search_result = child.dfs(target_value)
        return search_result unless search_result.nil?
      end
      return nil
    end
  end

  def bfs(target_value)
    queue = []
    queue << self
    until queue.empty?
      first = queue.shift
      return first if first.value == target_value
      queue += first.children
    end

    nil
  end

  def trace_path_back
    return [@value] if @parent.nil?
    @parent.trace_path_back << @value
  end

end
