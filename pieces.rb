class Pieces
  attr_accessor :pos,:color,:position,:deltas,:board, :king
  def initialize(board, color, position, king = false)
    @board = board
    @color = color
    @pos = position
    @deltas = set_deltas
    @deltas = set_deltas_king if king 
    @king = king
  end
  
  def set_deltas
    s = self.color == :b ? 1 : -1
    deltas = [[1, s*1], [-1, s*1]] 
  end
  
  def set_deltas_king
    deltas = [[1,1], [-1,1], [1,-1], [-1,-1]]
  end
  
  def slide_moves
    moves = possible_moves
    moves.select { |post|  @board.empty?(post) }.compact
  end
  
  def possible_moves
    moves = @deltas.map { |dx,dy| [pos[0]+dx, pos[1]+dy] }
    moves.select { |end_pos| @board.in_board?(end_pos) }
  end
  
  def jump_moves
    jumps = []
    @deltas.each do |dx,dy|
      end_pos = [pos[0] + 2*dx, pos[1] + 2*dy]
      nex_pos =[pos[0] + dx, pos[1] + dy]
      jumps << end_pos if jump_move?(nex_pos,end_pos)
    end
    jumps.compact
  end
  
  def jump_move?(nex_pos,end_pos)
    @board.in_board?(end_pos) && @board[nex_pos] && @board[nex_pos].color != self.color && @board.empty?(end_pos)
  end
  
  def  valid_moves
    slide_moves + jump_moves.compact
  end
  
  def make_jump(end_pos)
    nex_pos = [(end_pos[0] - pos[0]) / 2 + pos[0],(end_pos[1]-pos[1])/2+pos[1]]
    p nex_pos
    @board[pos] = nil
    @board[end_pos] = self
    @board[nex_pos] = nil
    self.pos = end_pos
  end
  
  def make_slide(end_pos)
    @board[pos] = nil
    @board[end_pos] = self
    self.pos = end_pos
  end
  
  def to_s
    return color == :b ? "♛" : "♛".colorize(:red) if king
    color == :b ? "♟" : "♟".colorize(:red)
  end
  
end