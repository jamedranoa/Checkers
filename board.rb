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
    
    raise InvalideMoveError, "Invalid move" if !valid_move?(move)
    piece = @board[start_pos]
    if is_jump?(move)
      piece.make_jump(end_pos)
      raise InvalideMoveError, "Make another Jump" if any_jumps?(piece.color)
      transform_kings
      return nil
    end
    raise InvalideMoveError, "Make Jump" if any_jumps?(piece.color)
    piece.make_slide(end_pos)
    transform_kings
  end
  
  def transform_kings
    find_kings.each {|piece| @board[piece.pos] = Pieces.new(piece.board, piece.color, piece.pos, true) }
  end
  
  def find_kings
   black_kings = find_pieces(:b).select { |piece| piece.pos[1] == 7 }
   red_kings = find_pieces(:r).select{ |piece| piece.pos[1] == 0 }
   black_kings + red_kings
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
    @board.select { |pos,piece| piece && piece.color == color }.values
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
    find_pieces(:b).empty? || find_pieces(:r).empty?
  end
  
  def in_board?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end
  
 
  protected
  def set_board
    rows=[[0,0],[1,1], [0,2], [1,5], [0,6], [1,7]]
    rows.each do |row|
      if row[1] > 2
        fill_row(row,:r)
        next
      end
      fill_row(row,:b)
    end
  end
  
  def fill_row(pos, col)
    while in_board?(pos)
      @board[pos] = Pieces.new(self, col, pos)
      pos =[pos[0]+2, pos[1]]
    end
  end
      

end




