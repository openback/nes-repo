require_relative 'nes'
require_relative 'datfile'
require_relative 'package'

class NesRepo
  def run
    FileUtils.mkdir_p($package_path) unless File.exists?($package_path)
    dat = DatFile::Clrmamepro.new($dat_path)

    Dir.glob("#{$roms_path}/*.nes") do |file|
      rom = NES.new(file)

      puts '=' * 80
      puts "#{file}"

      game_dat = dat.find_by_crc rom.crc

      if game_dat.nil?
        puts "ERROR: ROM not recognized\n"
        next
      end

      puts "Found ROM: #{game_dat.description}"

      package = Package.new
      package.rom_path = file
      package.name = game_dat.description.downcase.gsub(/\s/,'-').gsub(/[^\w-]/, '').gsub(/\-+/, '-') + "-nes"
      package.version = 1
      package.maintainer = $package_maintainer
      package.description = "#{rom.title} [NES]"
      package.description += "\n NES ROM for use with an emulator"
      # TODO: Why is it pausing between these two lines each loop?
      package.description += "\n Release Date: #{rom.release_date.iso8601}" if !rom.release_date.nil?
      package.description += "\n Mapper: #{rom.mapper}" if !rom.mapper.nil? and !rom.mapper.empty?
      package.description += "\n Publisher: #{rom.publisher}" if !rom.publisher.nil? and !rom.publisher.empty?
      package.description += "\n Developer: #{rom.developer}" if !rom.developer.nil? and !rom.developer.empty?
      package.description += "\n Co-op: " + (rom.coop? ? "Yes" : "No")
      package.description += "\n Overview: #{rom.overview}" if !rom.overview.nil? and !rom.overview.empty?
      package.create
    end
  end
end
