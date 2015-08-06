require 'colorize'

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

  def appearance
    picture = is_king? ? "O" : "O"
    "|#{picture.colorize(color)}"
  end

  # def possible_moves
  #   # you must take a jump if you can
  #
  # end

  def perform_slide
    # asks the board to do it, if possible
  end

  def perform_jump
    # asks the board to do it
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

  def possible_slides
    # returns array of positions that this piece can slide to
    is_king? ? slides(forward_dirs) + slides(backward_dirs) : slides(forward_dirs)
  end

  def slides(dirs)
    moves = []
    dirs.each do |x,y|
      next_pos = [pos[0] + x, pos[1] + y]
      moves << next_pos if board.open?(next_pos)
    end
    moves
  end

  def possible_jumps
    # you can jump if there is an enemy in front, who has an empty space behind them
    is_king? ? jumps(forward_dirs) + jumps(backward_dirs) : jumps(forward_dirs)
  end

  def jumps(dirs)
    moves = []
    dirs.each do |x,y|
      next_pos = [pos[0] + x, pos[1] + y]
      hop_pos = [next_pos[0] + x, next_pos[1] + y]
      moves << hop_pos if board.has_enemy?(next_pos, color) &&board.open?(hop_pos)
    end
    moves
  end

end
