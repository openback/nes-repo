require './lib/nes.rb'
require_relative './helpers.rb'

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
      expect(rom.ntsc?).to eq(true)
      expect(rom.pal?).to eq(false)
    end

    it "raises with invalid flags" do
      rom = NES.new(valid_rom_path)
      expect{rom.invalid_flag?}.to raise_error(NameError)
      # Not a Bit flag
      expect{rom.mirroring?}.to raise_error(NameError)
    end

    it "still raises with invalid properties" do
      rom = NES.new(valid_rom_path)
      expect{rom.not_a_thing}.to raise_error(NameError)
    end

    it "calculates the checksum without the header" do
      rom = NES.new(valid_rom_path)
      expect(rom.crc).to eql('6EE4BB0A')
    end
  end
end
