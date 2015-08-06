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

  def add_piece(piece, pos)
    self[pos] = piece
  end

  def self.in_board?(pos)
    pos.all? { |coord| coord.between?(0, BOARD_SIZE - 1)}
  end

  def open?(pos)
    Board.in_board?(pos) && self[pos].nil?
  end

  def make_move(start_pos, end_pos)
    # doesnt care about color or kingness, only position

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
      odds.each {|col| self[[row, col]] = Piece.new([row,col], self)}
    else
      evens.each {|col| self[[row, col]] = Piece.new([row,col],self)}
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
