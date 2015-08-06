class Piece

  UP_MOVE_DIRS = [[-1, -1], [-1, 1]]
  DOWN_MOVE_DIRS = [[1, -1], [1, 1]]

  attr_accessor :position, :color

  def initialize(position)
    @position = position
    # color either black or red, black's forward is up
    # @color = color
  end

  def forward_dirs
    color == :black ? UP_MOVE_DIRS : DOWN_MOVE_DIRS
  end

  def perform_slide
    # asks the board to do it, if possible
  end

  def perform_jump
    # asks the board to do it
  end

end
