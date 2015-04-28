class DatFile < File
	attr_accessor :games,
								:groups

	def initialize(filename)
		super(filename)

		first_line = gets

		begin
			raise IOError if first_line !~ /clrmamepro(\s*)?\(/
		rescue ArgumentError, IOError
			# Invalid UTF-8 got thrown for binary files or we simply threw it ourselves
      raise IOError, 'Invalid Dat file'
		end

		@games = Array.new
		@groups = Array.new

		while (line = gets)
			if line =~ /^game(\s*)?\(/ then
				gets # Parenthesis line
				game = Game.new
				line = gets.strip
				game.description = /^description\s*"(.+?)"$/.match(line)[1]
				line = gets.strip
				matches = /^rom\s*\(\s*name\s*"(.+?)"\s*?size\s*?(\d+)\s*?crc\s*?(\h+)\s*?md5\s*?(\h+)\s*?sha1\s*?(\h+)\s*?\)/.match(line)

				next if matches.nil?

				game.name, game.size, game.crc, game.md5, game.sha1 = matches.captures
				game.size = game.size.to_i
				game.group_name = game.name.match(/(.+?)\(/)[1].strip

				@groups << game.group_name
				@games << game
			end
		end

		@groups.uniq!
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
		game.group = group game.group_name
		game
	end

	def group(name)
		@games.select { |g| g.group_name == name }
	end

	class Game
		attr_accessor	:name,
									:group_name,
									:group,
									:description,
									:size,
									:crc,
									:md5,
									:sha1
		attr_writer		:games
	end
end
