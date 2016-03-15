require_relative './gamecollection'

class GameParser
  def self.parse stream
    raise ArgumentError.new('Must pass an IO stream') unless stream.respond_to? :gets

    raise IOError.new('Invalid Dat file') if stream.gets !~ /clrmamepro(\s*)?\(/

    puts stream.readlines.join.match(/^game\s+\((.*?^)\)$/m).captures.inspect
    
    lines.each do |game_dat|
      puts '-------'
      puts game_dat.inspect
    end

    return

    while line = stream.gets
      # found the start of a game declaration
      next unless line =~ /^game(\s*)?\(/
      game = parse_info read_game_lines

      next if game.nil?
    end
  end

  def parse_game dat
    @name = /\s+name\s+"(.*?)"$/m.match(dat).captures
    puts @name
  end

end
