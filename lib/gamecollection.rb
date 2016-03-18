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

  def find_by args
    raise ArgumentError unless args.length == 1 && Game.method_defined?("#{args.keys.first}?")
    @games.find { |game| game.send("#{args.keys.first}?", args.values.first) }
  end
end
