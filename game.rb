require_relative 'board'

class Game

  attr_reader :p1, :p2, :gameboard
  attr_accessor :current_player

  def initialize(p1, p2)
    @p1 = p1
    @p2 = p2
    @current_player = p1
    @gameboard = Board.new
  end

  def play
    puts "Play Checkers\n"
    until gameboard.over?

    end

  end

  def switch_player
    self.current_player = current_player == p1 ? p2 : p1
  end

end

class HumanPlayer
  attr_reader :name

  def initialize(name)
    @name = name
  end
end


if __FILE__ == $PROGRAM_NAME

end
