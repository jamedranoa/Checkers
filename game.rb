require "./board"
require "./pieces"
require './player'

class Game
  def initialize(player1,player2)
    @players = [player1, player2]
    @board = Board.new(true)
  end
  
  def turn(player)
    move=player.choose_movement
    raise InvalideMoveError, "That's not you" if @board[move[0]] && @board[move[0]].color != player.color
    @board.move(move)
  end
  
  def play
    while !@board.over?
      
      
      begin
        system "clear"
        print @board
        puts "#{@players.first} is your turn!"
        turn(@players.first)
      rescue  InvalideMoveError => e
        p e.message
        p "Try again, press return"
        gets
        retry
      end
      
      @players.rotate!
    end
    
    p "Game Over"
    print @board
    
  end
  
end


g = Game.new(Player.new(:b), Player.new(:r))

g.play