require 'bindata'
require 'nokogiri'
require 'open-uri'
require 'zlib'
require 'pp'

class NES
  attr_accessor :title
  attr_accessor :crc

  def initialize(filename)
    @rom = ROM.new
    @title = File.basename(filename, ".*" )
    # Will hold the actual ROM data
    nes_file  = nil

    File.open(filename) { |file|
      @rom.read file
      nes_file = File.read(file)
    }

    # calculate the checksum after chopping off the header
    nes_file = nes_file[16..(nes_file.length - 1)]
    @crc = Zlib.crc32(nes_file).to_s(16).upcase

    raise TypeError.new("Invalid file") if @rom.type != "NES\x1A"
  end

  def nes2_header?
    @rom.nes2 == 2
  end

  def coop?
    @game_data[:coop]
  end

  def prg_size_in_kilobytes
    @rom.prg_size_in_16kb_units * 16
  end

  def prg_size_in_bytes
    prg_size_in_kilobytes * 1024
  end

  def prg_ram_size_in_kilobytes
    @rom.prg_ram_size_in_8kb_units * 8
  end

  def prg_ram_size_in_bytes
    prg_ram_size_in_kilobytes * 1024
  end

  def chr_size_in_kilobytes
    @rom.chr_size_in_8kb_units * 8
  end

  def chr_size_in_bytes
    chr_size_in_kilobytes * 1024
  end

  def mirroring
    @rom.mirroring_flag.to_i.zero? ? :horizontal : :vertical
  end

  def tv_system
    @rom.tv_system_flag.to_i.zero? ? :ntsc : :pal
  end

  def ntsc?
    @rom.tv_system == :ntsc
  end

  def pal?
    @rom.tv_system == :pal
  end

  def mapper_number
    (@rom.mapper_high_nybble << 4) + @rom.mapper_low_nybble
  end

  def mapper
    # TODO: Default values for constant hashes?
    Mappers.has_key?(mapper_number) ? Mappers[mapper_number] : nil
  end

  private

  # Mapper list taken from:
  #
  # FCE Ultra - NES/Famicom Emulator
  #
  # Copyright notice for this file:
  #  Copyright (C) 1998 BERO
  #  Copyright (C) 2002 Xodnizel
  #
  # This program is free software; you can redistribute it and/or modify
  # it under the terms of the GNU General Public License as published by
  # the Free Software Foundation; either version 2 of the License, or
  # (at your option) any later version.
  #
  # This program is distributed in the hope that it will be useful,
  # but WITHOUT ANY WARRANTY; without even the implied warranty of
  # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  # GNU General Public License for more details.
  #
  # You should have received a copy of the GNU General Public License
  # along with this program; if not, write to the Free Software
  # Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
  Mappers = {
    0 => "NROM",
    1 => "MMC1",
    2 => "UNROM",
    3 => "CNROM",
    4 => "MMC3",
    5 => "MMC5",
    6 => "FFE Rev. A",
    7 => "ANROM",
    9 => "MMC2",
    10 => "MMC4",
    11 => "Color Dreams",
    12 => "REX DBZ 5",
    13 => "CPROM",
    14 => "REX SL-1632",
    15 => "100-in-1",
    16 => "BANDAI 24C02",
    17 => "FFE Rev. B",
    18 => "JALECO SS880006",
    19 => "Namcot 106",
    21 => "Konami VRC2/VRC4 A",
    22 => "Konami VRC2/VRC4 B",
    23 => "Konami VRC2/VRC4 C",
    24 => "Konami VRC6 Rev. A",
    25 => "Konami VRC2/VRC4 D",
    26 => "Konami VRC6 Rev. B",
    27 => "CC-21 MI HUN CHE",
    32 => "IREM G-101",
    33 => "TC0190FMC/TC0350FMR",
    34 => "IREM I-IM/BNROM",
    35 => "Wario Land 2",
    36 => "TXC Policeman",
    37 => "PAL-ZZ SMB/TETRIS/NWC",
    38 => "Bit Corp.",
    40 => "SMB2j FDS",
    41 => "CALTRON 6-in-1",
    42 => "BIO MIRACLE FDS",
    43 => "FDS SMB2j LF36",
    44 => "MMC3 BMC PIRATE A",
    45 => "MMC3 BMC PIRATE B",
    46 => "RUMBLESTATION 15-in-1",
    47 => "NES-QJ SSVB/NWC",
    48 => "TAITO TCxxx",
    49 => "MMC3 BMC PIRATE C",
    50 => "SMB2j FDS Rev. A",
    51 => "11-in-1 BALL SERIES",
    52 => "MMC3 BMC PIRATE D",
    53 => "SUPERVISION 16-in-1",
    57 => "SIMBPLE BMC PIRATE A",
    58 => "SIMBPLE BMC PIRATE B",
    60 => "SIMBPLE BMC PIRATE C",
    61 => "20-in-1 KAISER Rev. A",
    62 => "700-in-1",
    64 => "TENGEN RAMBO1",
    65 => "IREM-H3001",
    66 => "MHROM",
    67 => "SUNSOFT-FZII",
    68 => "Sunsoft Mapper #4",
    69 => "SUNSOFT-5/FME-7",
    70 => "BA KAMEN DISCRETE",
    71 => "CAMERICA BF9093",
    72 => "JALECO JF-17",
    73 => "KONAMI VRC3",
    74 => "TW MMC3+VRAM Rev. A",
    75 => "KONAMI VRC1",
    76 => "NAMCOT 108 Rev. A",
    77 => "IREM LROG017",
    78 => "Irem 74HC161/32",
    79 => "AVE/C&E/TXC BOARD",
    80 => "TAITO X1-005 Rev. A",
    82 => "TAITO X1-017",
    83 => "YOKO VRC Rev. B",
    85 => "KONAMI VRC7",
    86 => "JALECO JF-13",
    87 => "74*139/74 DISCRETE",
    88 => "NAMCO 3433",
    89 => "SUNSOFT-3",
    90 => "HUMMER/JY BOARD",
    91 => "EARLY HUMMER/JY BOARD",
    92 => "JALECO JF-19",
    93 => "SUNSOFT-3R",
    94 => "HVC-UN1ROM",
    95 => "NAMCOT 108 Rev. B",
    96 => "BANDAI OEKAKIDS",
    97 => "IREM TAM-S1",
    99 => "VS Uni/Dual- system",
    103 => "FDS DOKIDOKI FULL",
    105 => "NES-EVENT NWC1990",
    106 => "SMB3 PIRATE A",
    107 => "MAGIC CORP A",
    108 => "FDS UNROM BOARD",
    112 => "ASDER/NTDEC BOARD",
    113 => "HACKER/SACHEN BOARD",
    114 => "MMC3 SG PROT. A",
    115 => "MMC3 PIRATE A",
    116 => "MMC1/MMC3/VRC PIRATE",
    117 => "FUTURE MEDIA BOARD",
    118 => "TSKROM",
    119 => "NES-TQROM",
    120 => "FDS TOBIDASE",
    121 => "MMC3 PIRATE PROT. A",
    123 => "MMC3 PIRATE H2288",
    125 => "FDS LH32",
    132 => "TXC/MGENIUS 22111",
    133 => "SA72008",
    134 => "MMC3 BMC PIRATE",
    136 => "TCU02",
    137 => "S8259D",
    138 => "S8259B",
    139 => "S8259C",
    140 => "JALECO JF-11/14",
    141 => "S8259A",
    142 => "UNLKS7032",
    143 => "TCA01",
    144 => "AGCI 50282",
    145 => "SA72007",
    146 => "SA0161M",
    147 => "TCU01",
    148 => "SA0037",
    149 => "SA0036",
    150 => "S74LS374N",
    153 => "BANDAI SRAM",
    157 => "BANDAI BARCODE",
    159 => "BANDAI 24C01",
    160 => "SA009",
    166 => "SUBOR Rev. A",
    167 => "SUBOR Rev. B",
    176 => "BMCFK23C",
    192 => "TW MMC3+VRAM Rev. B",
    193 => "NTDEC TC-112",
    194 => "TW MMC3+VRAM Rev. C",
    195 => "TW MMC3+VRAM Rev. D",
    198 => "TW MMC3+VRAM Rev. E",
    206 => "NAMCOT 108 Rev. C",
    207 => "TAITO X1-005 Rev. B",
    219 => "UNLA9746",
    220 => "Debug Mapper",
    221 => "UNLN625092",
    226 => "BMC 22+20-in-1",
    230 => "BMC Contra+22-in-1",
    232 => "BMC QUATTRO",
    233 => "BMC 22+20-in-1 RST",
    234 => "BMC MAXI",
    238 => "UNL6035052",
    243 => "S74LS374NA",
    244 => "DECATHLON",
    246 => "FONG SHEN BANG",
    252 => "SAN GUO ZHI PIRATE",
    253 => "DRAGON BALL PIRATE",
  }

  def method_missing(method, *args, &block)
    # Checking a flag?
    if method.slice(method.length - 1) == '?'
      flag_name = method.to_s.chop
      flag_val = @rom.send(flag_name)

      raise NameError.new("undefined bitflag `#{flag_name}' for ROM") if flag_val.class != BinData::Bit1

      return ! flag_val.to_i.zero?
    end

    return @rom.send(method, *args) if @rom.respond_to?(method)
    # Welp
    super
  end

  #############################################################################
  class ROM < BinData::Record
    # byte 0-3
    string :type, :read_length => 4
    # byte 4
    uint8 :prg_size_in_16kb_units
    # byte 5
    uint8 :chr_size_in_8kb_units
    # 00100100
    # 76543210   # byte 6
    # ||||||||
    # |||||||+- 0xx0: horizontal mirroring (CIRAM A10 = PPU A11)
    # |||||||   0xx1: vertical mirroring (CIRAM A10 = PPU A10)
    # ||||||+-- 1: SRAM in CPU $6000-$7FFF, if present, is battery backed
    # |||||+--- 1: 512-byte trainer at $7000-$71FF (stored before PRG data)
    # ||||+---- 1xxx: four-screen VRAM
    # ++++----- Lower nybble of mapper number
    bit4 :mapper_low_nybble
    bit1 :four_screen_vram
    bit1 :has_trainer
    bit1 :battery_backed
    bit1 :mirroring_flag
    # 01000000
    # 76543210   # byte 7
    # ||||||||
    # |||||||+- VS Unisystem
    # ||||||+-- PlayChoice-10 (8KB of Hint Screen data stored after CHR data)
    # ||||++--- If equal to 2, flags 8-15 are in NES 2.0 format
    # ++++----- Upper nybble of mapper number
    bit4 :mapper_high_nybble
    bit2 :nes2
    bit1 :playchoice_10
    bit1 :vs_unisystem

    # byte 8
    uint8 :prg_ram_size_in_8kb_units
    ############ The following flags can't be trusted ###############
    # 76543210   # byte 9
    # ||||||||
    # |||||||+- TV system (0: NTSC; 1: PAL)
    # +++++++-- Reserved, set to zero
    bit7 :reserved1
    bit1 :tv_system_flag
    # byte 10-15
    skip :length => 6 # Reserved bytes
  end
end
