class GameCollection
#			@groups << game.group_name
  def initialize
    @games = []
  end

  def << game
    raise TypeError unless game.is_a? Game
    @games << game
  end

  def length
    @games.length
  end
end
