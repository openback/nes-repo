require 'fileutils'
require_relative 'nes'
require_relative 'datfile'

class NesRepo
  class Package
    attr_accessor :description
    attr_accessor :name
    # The ROM filename
    attr_accessor :rom_path
    # Your email address
    attr_accessor :maintainer
    # Name of the intended file. Do not append things such as version numbers or
    # architecture, as these will be done automatically as needed
    attr_accessor :version

    # For debian. No good reasone to change these.
    attr_reader :architecture
    attr_reader :priority
    attr_reader :section

    def initialize
      @section = 'all'
      @architecture = 'all'
      @priority = 'optional'
    end

    def get_debian_control
      control = {
        :package      => @name,
        :version      => @version ,
        :architecture => 'all',
        :maintainer   => @maintainer,
        :section      => 'games',
        :priority     => 'optional',
        :description  => @description
      }

      control.keys.reduce("") {|res, key| res += "#{key.to_s.capitalize}: #{control[key]}\n" }
    end

    def create
      package_dir = "#{$tmp_path}/#{@name}"

      FileUtils.mkdir_p("#{package_dir}/usr/share/games/roms/nes")
      FileUtils.copy(@rom_path, "#{package_dir}/usr/share/games/roms/nes/#{@name}")
      FileUtils.mkdir_p("#{package_dir}/DEBIAN")
      File.open("#{package_dir}/DEBIAN/control", 'w') { |f| f.write get_debian_control }

      puts `dpkg-deb -b "#{package_dir}" #{$package_path}`
      puts `reprepro -C main -Vb "#{$repo_path}" includedeb nes "#{$package_path}/#{@name}_1_all.deb"`

      FileUtils.rm_rf(package_dir)
    end
  end

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
