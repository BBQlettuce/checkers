require 'colorize'

# class InvalidMoveError < RuntimeError
# end

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

  def initialize(pos, board, color)
    @pos = pos
    @king = false
    @board = board
    @color = color
    board.add_piece(self, pos)
  end

  def appearance
    picture = is_king? ? "0" : "O"
    "|#{picture.colorize(color)}"
  end

  # can get rid of angle and stuff, and only take in a target pos;
  # then possible_slides and jumps can be simplified
  def perform_slide(target_pos)
    # dir = forward ? forward_dir : backward_dir
    # target_pos = [pos[0] + dir, pos[1] + angle]
    if possible_slides.include?(target_pos)
      board.delete_piece(pos)
      self.pos = target_pos
      board.add_piece(self, target_pos)
      return true
    else
      return false
    end
  end

  def perform_jump(target_pos)
    # dir = forward ? forward_dir : backward_dir
    # target_pos = [pos[0] + (dir * 2), pos[1] + (angle * 2)]
    if possible_jumps.include?(target_pos)
      # make the move
      avg_x = (start_pos[0] + target_pos[0]) / 2
      avg_y = (start_pos[1] + target_pos[1]) / 2
      board.delete_piece(pos)
      board.delete_piece([avg_x, avg_y])
      self.pos = target_pos
      board.add_piece(self, target_pos)
      return true
    else
      return false
    end
  end

  def perform_moves(move_sequence)
    if move_sequence.length == 1
      angle, forward = move_sequence.first
      return if perform_slide(angle, forward)
      return if perform_jump(angle, forward)
      raise "Cannot perform this move."
    else
      move_sequence.each do |move|
        angle, forward = move
        raise "Cannot perform this move." unless perform_jump(angle, forward)
      end
    end
  end

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

  def directions
    is_king? ? [forward_dir, backward_dir] : [forward_dir]
  end

  # def possible_slides
  #   # returns array of positions that this piece can slide to
  #   is_king? ? slides(forward_dir) + slides(backward_dir) : slides(forward_dir)
  # end

  def possible_slides
    moves = []
    directions.each do |dir|
      LEFT_AND_RIGHT.each do |angle|
        next_pos = [pos[0] + dir, pos[1] + angle]
        moves << next_pos if board.open?(next_pos)
      end
    end
    moves
  end

  # def possible_jumps
  #   # you can jump if there is an enemy in front, who has an empty space behind them
  #   is_king? ? jumps(forward_dir) + jumps(backward_dir) : jumps(forward_dir)
  # end

  def possible_jumps
    moves = []
    directions.each do |dir|
      LEFT_AND_RIGHT.each do |angle|
        next_pos = [pos[0] + dir, pos[1] + angle]
        hop_pos = [next_pos[0] + dir, next_pos[1] + angle]
        moves << hop_pos if board.has_enemy?(next_pos, color) && board.open?(hop_pos)
      end
    end
    moves
  end

end
