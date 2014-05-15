require './pieces'

class InvalideMoveError< StandardError  
end  

class Board
  def initialize(new_game = false)
    @board = Hash.new { |h, key| h[key] = nil }
    fill_board
    set_board if new_game
  end

  def fill_board
    (0..7).to_a.repeated_permutation(2).to_a.each{ |pos| @board[pos] }
  end
  
  def [](pos)
    @board[pos]
  end
  def []=(pos,val)
    @board[pos] = val
  end
  
  def empty?(pos)
    @board[pos] == nil
  end

  def move(move)
    start_pos, end_pos = move
    
    raise InvalideMoveError if !valid_move?(move)
    piece = @board[start_pos]
    if is_jump?(move)
      piece.make_jump(end_pos)
      raise InvalideMoveError, "Make another Jump" if any_jumps?(piece.color)
      return nil
    end
    raise InvalideMoveError, "Make Jump" if any_jumps?(piece.color)
    piece.make_slide(end_pos)
  end

  def valid_move?(move)
    start_pos,end_pos = move
    @board[start_pos] && empty?(end_pos) && @board[start_pos].valid_moves.include?(end_pos)
  end

  def is_jump?(move)
    start_pos, end_pos = move
    @board[start_pos].jump_moves.include?(end_pos)
  end

  def any_jumps?(color)
    find_pieces(color).any? { |piece| !piece.jump_moves.empty?}
  end

  def find_pieces(color)
    @board.select { |pos,piece| piece && piece.color == color}.values
  end

  def to_s
    str = ""
    7.downto(0) do |row|
      8.times do |col|
        if self[[col,row]]==nil
          str << "[ ]"
          next
        end
        str << "[#{@board[[col,row]]}]"
      end
      str << " #{row} \n"
    end
    str << " 0  1  2  3  4  5  6  7 \n "
    str
  end
    
    
  def over?
    find_pieces?(:b).empty? || find_pieces?(:r).empty?
  end
  
  def in_board?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end

end


b = Board.new
print b
b[[0,0]] = Pieces.new(b,:b,[0,0])
b[[1,1]] = Pieces.new(b,:r,[1,1])
puts
print b
puts
p b.any_jumps?(:b)
b.move([[0,0],[2,2]])
puts
print b
b.move([[2,2],[3,3]])
puts
print b
b[[4,4]] = Pieces.new(b,:r,[4,4])
puts
print b
b.move([[4,4],[2,2]])
puts
print b

b[[2,4]] = Pieces.new(b,:r,[2,4])
puts
print b
b.move([[3,3],[1,5]])
puts
print b
=begin
b.move([[3,3],[1,5]])
puts 
print b
=end
