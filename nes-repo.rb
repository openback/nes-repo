require_relative 'lib/nes-repo'

# TODO: globals needs to be in a config
#
# Where to put created packages. Probably should just use the temp path
# and delete after putting it into the final directory with reprepro for deb,
# at least
$package_path = "#{Dir.getwd}/debs"
$package_maintainer = 'openback@gmail.com'
$roms_path = 'ROMs'
$dat_path = 'util/NES.dat'
$tmp_path = '/tmp'
# Where the final repo lives, since with reprepro, it isn't where we just made the package
$repo_path = '/var/www/nes.repo.dev/'

repo = NesRepo.new
repo.run
