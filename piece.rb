class Piece

  UP_MOVE_DIRS = [[-1, -1], [-1, 1]]
  DOWN_MOVE_DIRS = [[1, -1], [1, 1]]

  attr_accessor :pos, :color, :king
  attr_reader :board

  def initialize(pos, board)
    @pos = pos
    @king = false
    @board = board
    board.add_piece(self, pos)
  end

  def possible_slides
    # returns array of positions that this piece can slide to
    forward_slides + backward_slides
  end

  def forward_slides
    moves = []
    #debugger
    forward_dirs.each do |x,y|
      next_pos = [pos[0] + x, pos[1] + y]
      moves << next_pos if board.open?(next_pos)
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
    # you can jump if there is an enemy in front, who has an empty space behind them
    forward_jumps + backward_jumps
  end

  def forward_jumps
    moves = []
    forward_dirs.each do |x,y|
      next_pos = [pos[0] + x, pos[1] + y]
      hop_pos = [next_pos[0] + x, next_pos[1] + y]
      moves << hop_pos if board.has_enemy?(next_pos) &&board.open?(hop_pos)
    end
    moves
  end

  def backward_jumps
    return [] if !is_king?
    moves = []
    backward_dirs.each do |x,y|
      next_pos = [pos[0] + x, pos[1] + y]
      hop_pos = [next_pos[0] + x, next_pos[1] + y]
      moves << hop_pos if board.has_enemy?(next_pos) &&board.open?(hop_pos)
    end
    moves
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
