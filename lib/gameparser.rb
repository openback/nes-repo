require_relative './gamecollection'
require_relative './game'

class GameParser
  QUOTED_REGEX = lambda { |name| /\s+#{name}\s+"(.*?)"/ }
  UNQUOTED_REGEX = lambda { |name| /\s+#{name}\s+(\w*)/ }

  def self.parse stream, maintainer, version=1
    raise ArgumentError.new('Must pass an IO stream') unless stream.respond_to? :gets
    raise ArgumentError.new('Invalid Dat file') if stream.gets !~ /clrmamepro(\s*)?\(/

    games = GameCollection.new

    while line = stream.gets
      next unless line =~ /^game(\s*)?\(/

      game_lines = ''

      until (line = stream.gets).nil? || line =~ /^\)$/
        game_lines += line
      end

      games << self.parse_game(game_lines, maintainer, version)
    end

    games
  end

  def self.parse_game dat, maintainer, version=1
    unquoted_vals = [:md5, :sha1, :crc]
    quoted_vals = [:name, :description]

    Game.new({ :maintainer => maintainer, :version => version }
      .merge(self.collect(dat, unquoted_vals, UNQUOTED_REGEX))
      .merge(self.collect(dat, quoted_vals, QUOTED_REGEX))
    )
  end

  private
  def self.collect dat, names, regex
      Hash[names.collect { |name| [name, regex.call(name.to_s).match(dat).captures[0]] }]
  end
end
