require_relative 'game'

module DatFile
  class Clrmamepro < File
    attr_accessor :games,
                  :groups

    def initialize(filename)
      super(filename)

      begin
        raise IOError if gets !~ /clrmamepro(\s*)?\(/
      rescue ArgumentError, IOError
        # Invalid UTF-8 got thrown for binary files or we simply threw it ourselves
        raise IOError, 'Invalid Dat file'
      end

      @games = Array.new
      @groups = Array.new

      while (line = gets)
        # found the start of a game declaration
        if line =~ /^game(\s*)?\(/ then
          game = parse_info read_game_lines

          next if game.nil?

          @groups << game.group_name
          @games << game
        end
      end

      @groups.uniq!
    end

    def read_game_lines
      lines = Array.new

      3.times do
        lines.push gets.strip
      end

      lines
    end

    def parse_info(lines)
      return nil if lines.nil? or lines.empty?

      game = Datfile::Game.new
      game.description = /^description\s*"(.+?)"$/.match(lines[1])[1]
      matches = /^rom\s*\(\s*name\s*"(.+?)"\s*?size\s*?(\d+)\s*?crc\s*?(\h+)\s*?md5\s*?(\h+)\s*?sha1\s*?(\h+)\s*?\)/.match(lines[2])

      return nil if matches.nil?

      game.name, game.size, game.crc, game.md5, game.sha1 = matches.captures
      game.size = game.size.to_i
      game.group_name = game.name.match(/(.+?)\(/)[1].strip

      game
    end

    def find_by_name(name)
      index = @games.find_index { |game| game.description == name }

      return nil if index.nil?
      game = @games[index]
      game.group = group game.group_name
      game
    end

    def find_by_crc(crc)
      index = @games.find_index { |game| game.crc == crc }

      return nil if index.nil?
      game = @games[index]
      # Make it easier to get to the group it's in
      game.group = group game.group_name
      game
    end

    def group(name)
      @games.select { |g| g.group_name == name }
    end
  end
end

