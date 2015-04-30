require 'fileutils'

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
