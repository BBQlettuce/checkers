class Board
  BOARD_SIZE = 8

  def initialize
    @grid = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE) }
  end
end
