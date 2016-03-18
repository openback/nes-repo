require 'minitest/autorun'
require_relative '../lib/gameparser'

EMPTYDAT = <<EOH
clrmamepro (
  name "Nintendo - Nintendo Entertainment System"
  description "Nintendo - Nintendo Entertainment System"
  header "No-Intro_NES.xml"
  version 20160229-061122
  comment "no-intro | www.no-intro.org"
)
EOH

MEGA_MAN_U = <<EOG
game (
  name "Mega Man (USA)"
  description "Mega Man (USA)"
  rom ( name "Mega Man (USA).nes" size 131072 crc 6EE4BB0A md5 4DE82CFCEADBF1A5E693B669B1221107 sha1 6047E52929DFE8ED4708D325766CCB8D3D583C7D )
)
EOG

MEGA_MAN_2_U = <<EOG
game (
  name "Mega Man 2 (USA)"
  description "Mega Man 2 (USA)"
  rom ( name "Mega Man 2 (USA).nes" size 262144 crc 0FCFC04D md5 0527A0EE512F69E08B8DB6DC97964632 sha1 2EC08F9341003DED125458DF8697CA5EF09D2209 )
)
EOG

MEGA_MAN_2_E = <<EOG
game (
  name "Mega Man 2 (Europe)"
  description "Mega Man 2 (Europe)"
  rom ( name "Mega Man 2 (Europe).nes" size 262144 crc A6638CBA md5 D76E9A94AEBBA887A6FCD1DA3375F48D sha1 E28BA80BE814BB032BBE4647C1B2104F868DFA25 )
)
EOG

DAT = [EMPTYDAT, MEGA_MAN_U, MEGA_MAN_2_U, MEGA_MAN_2_E].join " \n"

MEGA_MAN_U_CONTROL = <<-EOG.strip
Package: mega-man-usa-nes
Version: 2
Architecture: all
Maintainer: maintainer
Section: games
Priority: optional
Description: Mega Man (USA)
EOG

class GameParserTest < Minitest::Test
  def setup
    @datIO = StringIO.new(DAT)
    @games = GameParser.parse(@datIO, 'maintainer', 2)
    @datIO.seek(0)
  end

  def test_raises_without_io
    assert_raises(ArgumentError) { GameParser.parse(3, 'maintainer') }
    assert_raises(ArgumentError) { GameParser.parse(nil, 'maintainer') }
  end

  def test_raises_onunrecognized_stream
    @datIO.seek(3)
    assert_raises(ArgumentError) { GameParser.parse(@datIO, 'maintainer') }
  end

  def test_finds_all_games
    assert_equal(3, GameParser.parse(@datIO, 'maintainer').length)
  end

  def test_outputs_debian_control
    assert_equal(MEGA_MAN_U_CONTROL, GameParser.parse_game(MEGA_MAN_U, 'maintainer', 2).to_debian_control)
  end

  def test_returns_game_by_md5
    assert_equal(MEGA_MAN_U_CONTROL, @games.find_by(md5: '4DE82CFCEADBF1A5E693B669B1221107').to_debian_control)
  end

  def test_returns_game_by_sha1
    assert_equal(MEGA_MAN_U_CONTROL, @games.find_by(sha1: '6047E52929DFE8ED4708D325766CCB8D3D583C7D').to_debian_control)
  end

  def test_returns_game_by_crc
    assert_equal(MEGA_MAN_U_CONTROL, @games.find_by(crc: '6EE4BB0A').to_debian_control)
  end
end
