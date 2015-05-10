require_relative 'nes'
require_relative 'datfile'
require_relative 'package'

class NesRepo
  def run
    FileUtils.mkdir_p($package_path) unless File.exists?($package_path)
    dat = DatFile::Clrmamepro.new($dat_path)

    Dir.glob("#{$roms_path}/*.nes") do |file|
      puts '=' * 80
      puts "#{file}"

      begin
        rom = NES.new(file)
      rescue TypeError, SocketError => e
        puts "ERROR: #{e}\n"
        continue
      end

      game_dat = dat.find_by_crc rom.crc

      if game_dat.nil?
        puts "ERROR: ROM not recognized\n"
        next
      end

      puts "Found ROM: #{game_dat.description}"
      gamesdb_data = GamesDB::find(:nintendo_entertainment_system_nes, rom.title)

      package = Package.new
      package.rom_path = file
      package.name = game_dat.description.downcase.gsub(/\s/,'-').gsub(/[^\w-]/, '').gsub(/\-+/, '-') + "-nes"
      package.version = 1
      package.maintainer = $package_maintainer
      package.description = "#{rom.title} [NES]"
      package.description += "\n NES ROM for use with an emulator"
      # TODO: Why is it pausing between these two lines each loop?
      package.description += "\n Release Date: #{gamesdb_data.release_date.iso8601}" if !gamesdb_data.release_date.nil?
      package.description += "\n Mapper: #{rom.mapper}" if !rom.mapper.nil? and !rom.mapper.empty?
      package.description += "\n Publisher: #{gamesdb_data.publisher}" if !gamesdb_data.publisher.nil? and !gamesdb_data.publisher.empty?
      package.description += "\n Developer: #{gamesdb_data.developer}" if !gamesdb_data.developer.nil? and !gamesdb_data.developer.empty?
      package.description += "\n Co-op: " + (gamesdb_data.coop? ? "Yes" : "No")
      package.description += "\n Overview: #{gamesdb_data.overview}" if !gamesdb_data.overview.nil? and !gamesdb_data.overview.empty?
      package.create
    end
  end
end
