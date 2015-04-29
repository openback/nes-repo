require 'fileutils'
require_relative 'lib/nes'
require_relative 'lib/datfile'

dat = DatFile.new('util/NES.dat')
output_path = "#{Dir.getwd}/debs"
FileUtils.mkdir_p(output_path) unless File.exists?(output_path)

Dir.glob('ROMs/*.nes') do |file|
	rom = NES.new(file)
	puts '=' * 80
  puts "#{file}"

  game_dat = dat.find_by_crc rom.crc

  if game_dat.nil?
    puts "ERROR: ROM not recognized\n"
    next
  end

  puts "Found ROM: #{game_dat.description}"

	package_name = game_dat.description.downcase.gsub(/\s/,'-').gsub(/[^\w-]/, '').gsub(/\-+/, '-') + "-nes"
	package_dir = "/tmp/#{package_name}"

	FileUtils.mkdir_p("#{package_dir}/usr/share/games/roms/nes")
	FileUtils.copy(file, "#{package_dir}/usr/share/games/roms/nes/#{game_dat.name}")
	FileUtils.mkdir_p("#{package_dir}/DEBIAN")

	control = {
		:package      => package_name,
		:version      => 1 ,
		:architecture => 'all',
		:maintainer   => 'openback@gmail.com',
		:section      => 'games',
		:priority     => 'optional',
		:description  => "#{rom.title} [NES]"
	}

	control[:description] += "\n NES ROM for use with an emulator"
	control[:description] += "\n Release Date: #{rom.release_date.iso8601}" if !rom.release_date.nil?
	control[:description] += "\n Mapper: #{rom.mapper}" if !rom.mapper.nil? and !rom.mapper.empty?
	control[:description] += "\n Publisher: #{rom.publisher}" if !rom.publisher.nil? and !rom.publisher.empty?
	control[:description] += "\n Developer: #{rom.developer}" if !rom.developer.nil? and !rom.developer.empty?
	control[:description] += "\n Co-op: " + (rom.coop? ? "Yes" : "No")
	control[:description] += "\n Overview: #{rom.overview}" if !rom.overview.nil? and !rom.overview.empty?
	control_contents = control.keys.reduce("") {|res, key| res += "#{key.to_s.capitalize}: #{control[key]}\n" }
	File.open("#{package_dir}/DEBIAN/control", 'w') { |f| f.write control_contents }

	puts `dpkg-deb -b "#{package_dir}" #{output_path}`
  puts `reprepro -Vb /var/www/nes.repo.dev/ includedeb nes #{output_path}/#{package_name}_1_all.deb`

	FileUtils.rm_rf(package_dir)
end
