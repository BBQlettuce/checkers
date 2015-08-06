class Piece

  UP_MOVE_DIRS = [[-1, -1], [-1, 1]]
  DOWN_MOVE_DIRS = [[1, -1], [1, 1]]

  attr_accessor :pos, :color, :king
  attr_reader :board

  def initialize(pos, board)
    @pos = pos
    @king = false
    board.add_piece(self, pos)
    # need it to take in a board??
    # color either black or red, black's forward is up
    # @color = color
  end

  def possible_slides
    # returns array of positions that this piece can slide to
    forward_slides + backward_slides
  end

  def forward_slides
    moves = []
    forward_dirs.each do |x,y|
      next_pos = [pos[0] + x, pos[1] + y]
      moves << next_pos if board.open?(pos)
    end
    moves
  end

  def backward_slides
    return [] if !is_king?
    moves = []
    backward_dirs.each do |x,y|
      next_pos = [pos[0] + x, pos[1] + y]
      moves << next_pos if board.open?(pos)
    end
    moves
  end

  def possible_jumps

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
