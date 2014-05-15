class Player
  attr_reader :color
  def initialize(color)
    @color = color
  end
  
  def choose_movement
    move=[]
    puts "From?"
    move << translate(gets)
    puts "To?"
    move << translate(gets)
    move
  end
  
  def translate(str)
    str.chomp.split("").map(&:to_i)
  end
  
  def to_s
    self.color == :b ? "Black" : "Red"
  end
  
end