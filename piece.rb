require 'colorize'

class Piece

  UP = -1
  DOWN = 1
  LEFT = -1
  RIGHT = 1
  LEFT_AND_RIGHT = [LEFT, RIGHT]
  # UP_MOVE_DIRS = [[-1, -1], [-1, 1]]
  # DOWN_MOVE_DIRS = [[1, -1], [1, 1]]

  attr_accessor :pos, :color, :king
  attr_reader :board

  def initialize(pos, board)
    @pos = pos
    @king = false
    @board = board
    board.add_piece(self, pos)
  end

  def appearance
    picture = is_king? ? "0" : "O"
    "|#{picture.colorize(color)}"
  end

  #?????
  def perform_slide(angle, forward = true)
    dir = forward ? forward_dir : backward_dir
    target_pos = [pos[0] + dir, pos[1] + angle]
    board.make_move(pos, target_pos)
  end

  def perform_jump(angle, forward = true)
    dir = forward ? forward_dir : backward_dir
    target_pos = [pos[0] + (dir * 2), pos[1] + (angle * 2)]
    board.make_move(pos, target_pos)
  end
 #?????

  def is_king?
    king
  end

  def become_king
    self.king = true
  end

  def forward_dir
    color == :black ? UP : DOWN
  end

  def backward_dir
    color == :black ? DOWN : UP
  end

  def possible_slides
    # returns array of positions that this piece can slide to
    is_king? ? slides(forward_dir) + slides(backward_dir) : slides(forward_dir)
  end

  def slides(dir)
    moves = []
    LEFT_AND_RIGHT.each do |angle|
      next_pos = [pos[0] + dir, pos[1] + angle]
      moves << next_pos if board.open?(next_pos)
    end
    moves
  end

  def possible_jumps
    # you can jump if there is an enemy in front, who has an empty space behind them
    is_king? ? jumps(forward_dir) + jumps(backward_dir) : jumps(forward_dir)
  end

  def jumps(dir)
    moves = []
    LEFT_AND_RIGHT.each do |angle|
      next_pos = [pos[0] + dir, pos[1] + angle]
      hop_pos = [next_pos[0] + dir, next_pos[1] + angle]
      moves << hop_pos if board.has_enemy?(next_pos, color) && board.open?(hop_pos)
    end
    moves
  end

end
