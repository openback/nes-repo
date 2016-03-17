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

  def find_by_crc crc
    @games.find { |game| game.crc? crc }
  end

  def find_by_md5 md5
    @games.find { |game| game.md5? md5 }
  end

  def find_by_sha1 sha1
    @games.find { |game| game.sha1? sha1 }
  end
end
