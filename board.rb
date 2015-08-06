require 'byebug'
require_relative 'piece'

class Board
  BOARD_SIZE = 8

  attr_reader :grid

  def initialize(autofill = true)
    set_pieces(autofill)
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end

  def render
    grid.each do |row|
      row.each do |cell|
        print cell.nil? ? "| " : cell.appearance
      end
      print "|\n"
    end
  end

  def add_piece(piece, pos)
    raise "invalid position" unless open?(pos)
    self[pos] = piece
  end

  def delete_piece(pos)
    raise "no piece to delete" unless occupied?(pos)
    self[pos] = nil
  end

  def self.in_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE - 1)}
  end

  def open?(pos)
    Board.in_board?(pos) && self[pos].nil?
  end

  def occupied?(pos)
    Board.in_board?(pos) && !self[pos].nil?
  end

  def has_enemy?(pos, color)
    occupied?(pos) && self[pos].color != color
  end

  # def make_move(start_pos, end_pos)
  #   # doesnt care about color or kingness, but must be a jump if a jump is available
  #   # check if there is a piece at start_pos
  #   raise "No piece there!" unless occupied?(start_pos)
  #   chosen_piece = self[start_pos]
  #   # if this piece can jump, it must jump
  #   if chosen_piece.possible_jumps.include?(end_pos)
  #     # make the move
  #     avg_x = (start_pos[0] + end_pos[0]) / 2
  #     avg_y = (start_pos[1] + end_pos[1]) / 2
  #     chosen_piece.pos = end_pos
  #     add_piece(chosen_piece, end_pos)
  #     delete_piece(start_pos)
  #     delete_piece([avg_x, avg_y])
  #   elsif must_jump?(chosen_piece.color)
  #     raise "You must take a piece if it's available!"
  #   elsif chosen_piece.possible_slides.include?(end_pos)
  #     chosen_piece.pos = end_pos
  #     add_piece(chosen_piece, end_pos)
  #     delete_piece(start_pos)
  #   else
  #     raise "You can't move there."
  #   end
  # end

  # all the pieces of a color
  def team(color)
    grid.flatten.compact.select { |piece| piece.color == color}
  end

  # true if there are any jumps available for this team
  def must_jump?(color)
    team(color).any? { |piece| !piece.possible_jumps.empty?}
  end

  def set_pieces(autofill)
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
    place_starting_pieces if autofill
  end

  def place_starting_pieces
    # fill rows except rows 3 and 4
    grid.each_index do |row|
      fill_row(row) if row != 3 && row != 4
    end
    set_starting_colors
  end

  def fill_row(row)
    # even rows place pieces at 1,3,5,7
    # odd rows place pieces at 0,2,4,6
    odds = (0...BOARD_SIZE).select { |x| x.odd? }
    evens = (0...BOARD_SIZE).select { |x| x.even? }
    if row.even?
      odds.each {|col| Piece.new([row,col], self)}
    else
      evens.each {|col| Piece.new([row,col],self)}
    end
  end

  def set_starting_colors
    pieces = grid.flatten.compact
    pieces.each do |piece|
      x, _ = piece.pos
      #set color based on position
      piece.color = x < BOARD_SIZE / 2 ? :red : :black
    end
  end

end

if __FILE__ == $PROGRAM_NAME

end
