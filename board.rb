class Board
  def initialize(new_game = false)
    @board = Hash.new { |h, key| h[key] = nil }
    fill_board
    set_board if new_game
  end

  def fill_board
    (0..7).to_a.permutation(2).to_a.each{ |pos| @board[pos] }
  end

  def empty?(pos)
    @board[pos] == nil
  end

  def move(move)
    start_pos, end_pos = move

    raise InvalideMoveError if !valid_move(star_pos,end_pos)
    piece = @board[star_pos]
    if is_jump?(start_pos,end_pos)
      piece.make_jump
      return nil
    end
    raise InvalideMoveError, "Make Jump" if any_jumps?(color)
    piece.make_slide
  end

  def valid_move(star_pos,end_pos)
    empty?(star_pos) && @board[star_pos].valid_moves.include?(end_pos)
  end

  def is_jump?(start_pos,end_pos)
    @board[start_pos].jump_moves.include?(end_pos)
  end

  def any_jumps?(color)
    find_pieces(color).any? { |piece| !piece.jump_moves.empty?}
  end

  def find_pieces?(color)
    @board.select { |pos,piece| piece && piece.color == color}
  end

  def to_s
  end

  def board_over?
    find_pieces?(:b).empty? || find_pieces?(:r).empty?
  end

end


