require 'minitest/autorun'

require_relative '../gameparser'

class GameDatTest < Minitest::Test

	EMPTYDAT = <<EOH
clrmamepro (
	name "Nintendo - Nintendo Entertainment System"
	description "Nintendo - Nintendo Entertainment System"
	header "No-Intro_NES.xml"
	version 20160229-061122
	comment "no-intro | www.no-intro.org"
)
EOH

	MEGAMANU = <<EOG
game (
	name "Mega Man (USA)"
	description "Mega Man (USA)"
	rom ( name "Mega Man (USA).nes" size 131072 crc 6EE4BB0A md5 4DE82CFCEADBF1A5E693B669B1221107 sha1 6047E52929DFE8ED4708D325766CCB8D3D583C7D )
)
EOG

	MEGAMAN2U = <<EOG
game (
	name "Mega Man 2 (USA)"
	description "Mega Man 2 (USA)"
	rom ( name "Mega Man 2 (USA).nes" size 262144 crc 0FCFC04D md5 0527A0EE512F69E08B8DB6DC97964632 sha1 2EC08F9341003DED125458DF8697CA5EF09D2209 )
)
EOG

	MEGAMAN2E = <<EOG
game (
	name "Mega Man 2 (Europe)"
	description "Mega Man 2 (Europe)"
	rom ( name "Mega Man 2 (Europe).nes" size 262144 crc A6638CBA md5 D76E9A94AEBBA887A6FCD1DA3375F48D sha1 E28BA80BE814BB032BBE4647C1B2104F868DFA25 )
)
EOG

	DAT = [EMPTYDAT, MEGAMANU, MEGAMAN2U, MEGAMAN2E].join " \n"

	MEGA_MAN_CONTROL = <<EOG
Package: mega-man-usa-nes
Version: 1
Architecture: all
Maintainer: openback
Section: games
Priority: optional
Description: Mega Man (USA)
EOG

  def setup
    @datio = StringIO.new(DAT)
  end
    
  def test_does_not_parse_nonse
    assert_raises(ArgumentError) { GameParser.parse(3) }
    assert_raises(ArgumentError) { GameParser.parse(nil) }
    GameParser.parse(@datio)
    @datio.seek(3)
    assert_raises(IOError) { GameParser.parse(@datio) }
  end

	def test_can_parse_game
		assert_equal(MEGA_MAN_CONTROL, GameParser.parse_game(MEGAMANU).to_debian_control)
	end                            

  # def test_returns_game
  #   games = GameParser.parse(@datio)
  #   assert_equal(mega_man, games.find_by_md5('D76E9A94AEBBA887A6FCD1DA3375F48D').to_debian_control)
  # end
end
