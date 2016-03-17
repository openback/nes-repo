require_relative './gamecollection'
require_relative './game'

class GameParser
  def self.parse stream, maintainer, version=1
    raise ArgumentError.new('Must pass an IO stream') unless stream.respond_to? :gets
    raise ArgumentError.new('Invalid Dat file') if stream.gets !~ /clrmamepro(\s*)?\(/

    games = GameCollection.new

    while line = stream.gets
      # found the start of a game declaration
      next unless line =~ /^game(\s*)?\(/

      game_lines = line

      while line = stream.gets
        game_lines += line
        break if line =~ /^\)$/
      end

      games << self.parse_game(game_lines, maintainer, version)
    end

    games
  end

  def self.parse_game dat, maintainer, version=1
    Game.new({
      :name => self.get_quoted_val(dat, 'name'),
      :description => self.get_quoted_val(dat, 'description'),
      :maintainer => maintainer,
      :md5 => self.get_val(dat, 'md5'),
      :sha1 => self.get_val(dat, 'sha1'),
      :crc => self.get_val(dat, 'crc'),
      :version => version
    })
  end

  private
  def self.get_quoted_val dat, name
    /\s+#{name}\s+"(.*?)"/m.match(dat).captures[0]
  end

  def self.get_val dat, name
    /\s+#{name}\s+(\w*)/m.match(dat).captures[0]
  end
end
