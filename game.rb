require 'byebug'
require_relative 'board'

class Game

  attr_reader :p1, :p2, :gameboard
  attr_accessor :current_player

  def initialize(p1, p2)
    @p1 = p1
    p1.color = :black
    @p2 = p2
    p2.color = :red
    @current_player = p1
    @gameboard = Board.new
  end

  def play
    puts "Play Checkers\n"
    until gameboard.over?
      gameboard.render
      announce_turn(current_player)
      picked_piece = current_player.prompt_for_piece(gameboard)
      current_player.prompt_for_move_seq(picked_piece)
      gameboard.assign_kings
      switch_players
    end
    gameboard.render
    switch_players
    puts "#{current_player.name} wins!"
  end

  def switch_players
    self.current_player = current_player == p1 ? p2 : p1
  end

  def announce_turn(player)
    puts "#{player.name}'s turn. Which piece do you want to move?"
  end

  def self.translate_move_seq(piece, letter_inputs)
    pos = piece.pos
    dir = piece.forward_dir
    # stuff changes depending on the # of inputs
    step = letter_inputs.length == 1 ? 1 : 2
    output_targets = []
    letter_inputs.each do |input|
      case input
      when "l"
        output_targets << [pos[0] + step * dir, pos[1] - step]
      when "r"
        output_targets << [pos[0] + step * dir, pos[1] + step]
      when "bl"
        output_targets << [pos[0] - step * dir, pos[1] - step]
      when "br"
        output_targets << [pos[0] - step * dir, pos[1] + step]
      end
      pos = output_targets.last
    end

    output_targets
  end

end

class HumanPlayer
  attr_reader :name
  attr_accessor :color

  def initialize(name)
    @name = name
  end

  def ask_for_position
    gets.chomp.split(",").map { |el| Integer(el) }
  end

  def ask_for_move_seq
    puts "Input a sequence of one or more directions (l/r/bl/br)"
    input = gets.chomp.split(",")
    if input.any? { |el| !["l", "r", "bl", "br"].include?(el) }
      raise "Only input l/r (or bl/br for kings)"
    end
    input
  end

  def prompt_for_piece(gameboard)
    begin
      picked_pos = ask_for_position
      raise "Nothing there!" if gameboard[picked_pos].nil?
      picked_piece = gameboard[picked_pos]
      if picked_wrong_color(picked_piece.color)
        raise "You can't move your opponent's piece!"
      end
      if picked_piece.no_moves?
        raise "This piece has nowhere to go!"
      end
      if not_jumping_when_obligated(gameboard, picked_piece)
        raise "You must jump! Pick another piece."
      end
    rescue ArgumentError
      puts "Put in a real position!"
      retry
    rescue RuntimeError => e
      puts e.message
      puts "Try again."
      retry
    else
      return picked_piece
    end
  end

  def prompt_for_move_seq(picked_piece)
    begin
      letter_inputs = ask_for_move_seq
      move_sequence = Game.translate_move_seq(picked_piece, letter_inputs)
      picked_piece.perform_moves(move_sequence)
    rescue RuntimeError => e
      puts e.message
      puts "Try again."
      retry
    end
  end

  # can't pick your opponent's piece
  def picked_wrong_color(picked_color)
    color != picked_color
  end

  # picking a nonjumping piece when you must jump
  def not_jumping_when_obligated(gameboard, piece)
    gameboard.must_jump?(piece.color) && piece.possible_jumps.empty?
  end
end


if __FILE__ == $PROGRAM_NAME
  p1 = HumanPlayer.new("A")
  p2 = HumanPlayer.new("B")
  game = Game.new(p1, p2)
  game.play
end
