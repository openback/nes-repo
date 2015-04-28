require './lib/nes.rb'
require 'nokogiri'

RSpec.describe 'NES' do
  let(:valid_rom_path) { 'util/ROMs/Mega Man.nes' }

  context 'With an invalid ROM' do
    it "should raise" do
      expect{NES.new('Rakefile')}.to raise_error(TypeError)
    end
  end

  context 'With a valid ROM' do
    it "returns proper bit flags/properties from the ROM" do
      rom = NES.new(valid_rom_path)

      # We're going to make sure it doesn't call out unlesss it has to
      allow(rom).to receive_messages(
        :get_gameslist => nil,
        :get_game => nil
      )

      expect(rom.prg_size_in_16kb_units).to eq(8)
      expect(rom.prg_size_in_kilobytes).to eq(8 * 16)
      expect(rom.prg_size_in_bytes).to eq(8 * 16 * 1024)
      expect(rom.chr_size_in_8kb_units).to eq(0)
      expect(rom.chr_size_in_kilobytes).to eq(0)
      expect(rom.chr_size_in_bytes).to eq(0)
      expect(rom.mapper_number).to eq(66)
      expect(rom.mapper).to eq("MHROM")
      expect(rom.mirroring).to eq(:vertical)
      expect(rom.battery_backed).to eq(0)
      expect(rom.battery_backed?).to be false
      expect(rom.has_trainer?).to be false
      expect(rom.four_screen_vram?).to be false
      expect(rom.vs_unisystem?).to be false
      expect(rom.playchoice_10?).to be false
      expect(rom.nes2_header?).to be false
      expect(rom.prg_ram_size_in_8kb_units).to eq(0)
      expect(rom.prg_ram_size_in_kilobytes).to eq(0)
      expect(rom.prg_ram_size_in_bytes).to eq(0)
      expect(rom.tv_system).to eq(:ntsc)
      # Did it call out?
      expect(rom).to_not have_received(:get_gameslist)
      expect(rom).to_not have_received(:get_game)
    end

    it "raises with invalid flags" do
      rom = NES.new(valid_rom_path)
      expect{rom.invalid_flag?}.to raise_error(NameError)
    end

    it "calculates the checksum without the header" do
      rom = NES.new(valid_rom_path)
      expect(rom.crc).to eql('6EE4BB0A')
    end

    it "fetches game data when queried" do
      gameslist = <<-EOXML
        <?xml version="1.0" encoding="UTF-8" ?>
        <Data>
          <Game>
            <id>361</id>
            <GameTitle>Mega Man 2</GameTitle>
            <ReleaseDate>11/24/1988</ReleaseDate>
            <Platform>Nintendo Entertainment System (NES)</Platform>
          </Game>
          <Game>
            <id>360</id>
            <GameTitle>Mega Man</GameTitle>
            <ReleaseDate>12/17/1987</ReleaseDate>
            <Platform>Nintendo Entertainment System (NES)</Platform>
          </Game>
        </Data>
      EOXML

      game = <<-EOXML
        <?xml version="1.0" encoding="UTF-8"?>
        <Data>
          <baseImgUrl>http://thegamesdb.net/banners/</baseImgUrl>
          <Game>
            <id>360</id>
            <GameTitle>Mega Man</GameTitle>
            <PlatformId>7</PlatformId>
            <Platform>Nintendo Entertainment System (NES)</Platform>
            <ReleaseDate>12/17/1987</ReleaseDate>
            <Overview>Mega Man entails the events after the co-creation of the humanoid robot named Mega Man by the genius Dr. Wright (named Dr. Light in later titles) and his assistant Dr. Wily. The two scientists also create six other advanced robots: Cut Man, Elec Man, Ice Man, Fire Man, Bomb Man and Guts Man. Each of these robots is designed to perform industrial tasks involving construction, demolition, logging, electrical operations, or labor in extreme temperatures, all for the benefit of mankind in a location known as "Monsteropolis". However, Dr. Wily grows disloyal of his partner and reprograms these six robots to aid himself in taking control of the world. Dr. Wright sends Mega Man to defeat his fellow creations and put a stop to Dr. Wily. After succeeding, Mega Man returns home to his robot sister Roll and their creator Dr. Wright.</Overview>
            <ESRB>E - Everyone</ESRB>
            <Genres>
              <genre>Action</genre>
            </Genres>
            <Players>1</Players>
            <Co-op>No</Co-op>
            <Publisher>Capcom</Publisher>
            <Developer>Capcom</Developer>
            <Rating>7.5</Rating>
            <Similar>
              <SimilarCount>1</SimilarCount>
              <Game>
                <id>17794</id>
                <PlatformId>20</PlatformId>
              </Game>
            </Similar>
            <Images>
              <fanart>
                <original width="1920" height="1080">fanart/original/360-1.jpg</original>
                <thumb>fanart/thumb/360-1.jpg</thumb>
              </fanart>
              <fanart>
                <original width="1920" height="1080">fanart/original/360-2.jpg</original>
                <thumb>fanart/thumb/360-2.jpg</thumb>
              </fanart>
              <fanart>
                <original width="1920" height="1080">fanart/original/360-3.jpg</original>
                <thumb>fanart/thumb/360-3.jpg</thumb>
              </fanart>
              <fanart>
                <original width="1920" height="1080">fanart/original/360-4.jpg</original>
                <thumb>fanart/thumb/360-4.jpg</thumb>
              </fanart>
              <fanart>
                <original width="1920" height="1080">fanart/original/360-5.jpg</original>
                <thumb>fanart/thumb/360-5.jpg</thumb>
              </fanart>
              <fanart>
                <original width="1920" height="1080">fanart/original/360-6.jpg</original>
                <thumb>fanart/thumb/360-6.jpg</thumb>
              </fanart>
              <boxart side="back" width="1540" height="2100" thumb="boxart/thumb/original/back/360-1.jpg">boxart/original/back/360-1.jpg</boxart>
              <boxart side="front" width="1526" height="2100" thumb="boxart/thumb/original/front/360-1.jpg">boxart/original/front/360-1.jpg</boxart>
              <banner width="760" height="140">graphical/360-g.jpg</banner>
              <screenshot>
                <original width="425" height="383">screenshots/360-1.jpg</original>
                <thumb>screenshots/thumb/360-1.jpg</thumb>
              </screenshot>
              <clearlogo width="400" height="120">clearlogo/360.png</clearlogo>
            </Images>
          </Game>
        </Data>
      EOXML

      rom = NES.new(valid_rom_path)
      allow(rom).to receive_messages(
        :get_gameslist => Nokogiri::XML(gameslist),
        :get_game => Nokogiri::XML(game)
      )

      expect(rom.release_date).to eql(Date.parse("1987-12-17"))
      expect(rom.overview.length).to be(833)
      expect(rom.publisher).to eq("Capcom")
      expect(rom.developer).to eq("Capcom")
      expect(rom.coop).to eq(false)
      expect(rom.players).to eq(1)
      # Call at least one of them again to make sure that it still won't call
      # out again
      expect(rom.players).to eq(1)
      expect(rom).to have_received(:get_gameslist).once
      expect(rom).to have_received(:get_game).once
    end
  end
end
