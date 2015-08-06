class Piece

  UP_MOVE_DIRS = [[-1, -1], [-1, 1]]
  DOWN_MOVE_DIRS = [[1, -1], [1, 1]]

  attr_accessor :position, :color, :king

  def initialize(pos)
    @position = pos
    @king = false
    # color either black or red, black's forward is up
    # @color = color
  end

  def possible_moves
    
  end

  def is_king?
    king
  end

  def forward_dirs
    color == :black ? UP_MOVE_DIRS : DOWN_MOVE_DIRS
  end

  def backward_dirs
    color == :black ? DOWN_MOVE_DIRS : UP_MOVE_DIRS
  end

  def perform_slide
    # asks the board to do it, if possible
  end

  def perform_jump
    # asks the board to do it
  end

end
