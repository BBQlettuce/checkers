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
    system('clear')
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

  def pieces
    grid.flatten.compact
  end

  def dup
    dup_board = Board.new(false)
    pieces.each do |piece|
      dup_pos = piece.pos.dup
      Piece.new(dup_pos, dup_board, piece.color)
    end
    dup_board
  end

  # run this after every turn to set kings if possible
  def assign_kings
    # black pieces become kings when they hit row 0
    # red pieces become kings when they hit row 7
    grid[0].each do |cell|
      cell.become_king if !cell.nil? && cell.color == :black
    end
    grid[7].each do |cell|
      cell.become_king if !cell.nil? && cell.color == :red
    end
  end

  def team(color)
    pieces.select { |piece| piece.color == color}
  end

  # true if there are any jumps available for this team
  def must_jump?(color)
    team(color).any? { |piece| !piece.possible_jumps.empty?}
  end

  def winner
    :red if no_more_pieces(:black) || no_more_moves(:black)
    :black if no_more_pieces(:red) || no_more_moves(:red)
    nil
  end

  def over?
    !winner.nil?
  end

  # lose conditions
  def no_more_moves(color)
    team(color).all? do |piece|
      piece.possible_slides.empty? && piece.possible_jumps.empty?
    end
  end

  def no_more_pieces(color)
    team(color).empty?
  end

  private

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
      odds.each {|col| Piece.new([row,col], self, nil)}
    else
      evens.each {|col| Piece.new([row,col], self, nil)}
    end
  end

  def set_starting_colors
    pieces.each do |piece|
      x, _ = piece.pos
      #set color based on position
      piece.color = x < BOARD_SIZE / 2 ? :red : :black
    end
  end

end
