require 'nokogiri'

module Helpers
  class GamesDB
    def self.platforms_response
      @platforms_response ||= Nokogiri::XML(
        <<-EOXML
          <?xml version="1.0" encoding="UTF-8"?>
          <Data>
            <basePlatformUrl>http://thegamesdb.net/platform/</basePlatformUrl>
            <Platforms>
              <Platform>
                <id>25</id>
                <name>3DO</name>
                <alias>3do</alias>
              </Platform>
              <Platform>
                <id>4911</id>
                <name>Amiga</name>
                <alias>amiga</alias>
              </Platform>
              <Platform>
                <id>4914</id>
                <name>Amstrad CPC</name>
                <alias>amstrad-cpc</alias>
              </Platform>
              <Platform>
                <id>4916</id>
                <name>Android</name>
                <alias>android</alias>
              </Platform>
              <Platform>
                <id>23</id>
                <name>Arcade</name>
                <alias>arcade</alias>
              </Platform>
              <Platform>
                <id>22</id>
                <name>Atari 2600</name>
                <alias>atari-2600</alias>
              </Platform>
              <Platform>
                <id>26</id>
                <name>Atari 5200</name>
                <alias>atari-5200</alias>
              </Platform>
              <Platform>
                <id>27</id>
                <name>Atari 7800</name>
                <alias>atari-7800</alias>
              </Platform>
              <Platform>
                <id>28</id>
                <name>Atari Jaguar</name>
                <alias>atari-jaguar</alias>
              </Platform>
              <Platform>
                <id>29</id>
                <name>Atari Jaguar CD</name>
                <alias>atari-jaguar-cd</alias>
              </Platform>
              <Platform>
                <id>4924</id>
                <name>Atari Lynx</name>
                <alias>atari-lynx</alias>
              </Platform>
              <Platform>
                <id>30</id>
                <name>Atari XE</name>
                <alias>atari-xe</alias>
              </Platform>
              <Platform>
                <id>31</id>
                <name>Colecovision</name>
                <alias>colecovision</alias>
              </Platform>
              <Platform>
                <id>40</id>
                <name>Commodore 64</name>
                <alias>commodore-64</alias>
              </Platform>
              <Platform>
                <id>4928</id>
                <name>Fairchild Channel F</name>
              </Platform>
              <Platform>
                <id>32</id>
                <name>Intellivision</name>
                <alias>intellivision</alias>
              </Platform>
              <Platform>
                <id>4915</id>
                <name>iOS</name>
                <alias>ios</alias>
              </Platform>
              <Platform>
                <id>37</id>
                <name>Mac OS</name>
                <alias>mac-os</alias>
              </Platform>
              <Platform>
                <id>4927</id>
                <name>Magnavox Odyssey 2</name>
                <alias>magnavox-odyssey-2</alias>
              </Platform>
              <Platform>
                <id>14</id>
                <name>Microsoft Xbox</name>
                <alias>microsoft-xbox</alias>
              </Platform>
              <Platform>
                <id>15</id>
                <name>Microsoft Xbox 360</name>
                <alias>microsoft-xbox-360</alias>
              </Platform>
              <Platform>
                <id>4920</id>
                <name>Microsoft Xbox One</name>
                <alias>microsoft-xbox-one</alias>
              </Platform>
              <Platform>
                <id>4929</id>
                <name>MSX</name>
                <alias>msx</alias>
              </Platform>
              <Platform>
                <id>4922</id>
                <name>Neo Geo Pocket</name>
                <alias>neo-geo-pocket</alias>
              </Platform>
              <Platform>
                <id>4923</id>
                <name>Neo Geo Pocket Color</name>
                <alias>neo-geo-pocket-color</alias>
              </Platform>
              <Platform>
                <id>24</id>
                <name>NeoGeo</name>
                <alias>neogeo</alias>
              </Platform>
              <Platform>
                <id>4912</id>
                <name>Nintendo 3DS</name>
                <alias>nintendo-3ds</alias>
              </Platform>
              <Platform>
                <id>3</id>
                <name>Nintendo 64</name>
                <alias>nintendo-64</alias>
              </Platform>
              <Platform>
                <id>8</id>
                <name>Nintendo DS</name>
                <alias>nintendo-ds</alias>
              </Platform>
              <Platform>
                <id>7</id>
                <name>Nintendo Entertainment System (NES)</name>
                <alias>nintendo-entertainment-system-nes</alias>
              </Platform>
              <Platform>
                <id>4</id>
                <name>Nintendo Game Boy</name>
                <alias>nintendo-gameboy</alias>
              </Platform>
              <Platform>
                <id>5</id>
                <name>Nintendo Game Boy Advance</name>
                <alias>nintendo-gameboy-advance</alias>
              </Platform>
              <Platform>
                <id>41</id>
                <name>Nintendo Game Boy Color</name>
                <alias>nintendo-gameboy-color</alias>
              </Platform>
              <Platform>
                <id>2</id>
                <name>Nintendo GameCube</name>
                <alias>nintendo-gamecube</alias>
              </Platform>
              <Platform>
                <id>4918</id>
                <name>Nintendo Virtual Boy</name>
                <alias>nintendo-virtual-boy</alias>
              </Platform>
              <Platform>
                <id>9</id>
                <name>Nintendo Wii</name>
                <alias>nintendo-wii</alias>
              </Platform>
              <Platform>
                <id>38</id>
                <name>Nintendo Wii U</name>
                <alias>nintendo-wii-u</alias>
              </Platform>
              <Platform>
                <id>4921</id>
                <name>Ouya</name>
                <alias>ouya</alias>
              </Platform>
              <Platform>
                <id>1</id>
                <name>PC</name>
                <alias>pc</alias>
              </Platform>
              <Platform>
                <id>4917</id>
                <name>Philips CD-i</name>
                <alias>philips-cd-i</alias>
              </Platform>
              <Platform>
                <id>33</id>
                <name>Sega 32X</name>
                <alias>sega-32x</alias>
              </Platform>
              <Platform>
                <id>21</id>
                <name>Sega CD</name>
                <alias>sega-cd</alias>
              </Platform>
              <Platform>
                <id>16</id>
                <name>Sega Dreamcast</name>
                <alias>sega-dreamcast</alias>
              </Platform>
              <Platform>
                <id>20</id>
                <name>Sega Game Gear</name>
                <alias>sega-game-gear</alias>
              </Platform>
              <Platform>
                <id>18</id>
                <name>Sega Genesis</name>
                <alias>sega-genesis</alias>
              </Platform>
              <Platform>
                <id>35</id>
                <name>Sega Master System</name>
                <alias>sega-master-system</alias>
              </Platform>
              <Platform>
                <id>36</id>
                <name>Sega Mega Drive</name>
                <alias>sega-mega-drive</alias>
              </Platform>
              <Platform>
                <id>17</id>
                <name>Sega Saturn</name>
                <alias>sega-saturn</alias>
              </Platform>
              <Platform>
                <id>4913</id>
                <name>Sinclair ZX Spectrum</name>
                <alias>sinclair-zx-spectrum</alias>
              </Platform>
              <Platform>
                <id>10</id>
                <name>Sony Playstation</name>
                <alias>sony-playstation</alias>
              </Platform>
              <Platform>
                <id>11</id>
                <name>Sony Playstation 2</name>
                <alias>sony-playstation-2</alias>
              </Platform>
              <Platform>
                <id>12</id>
                <name>Sony Playstation 3</name>
                <alias>sony-playstation-3</alias>
              </Platform>
              <Platform>
                <id>4919</id>
                <name>Sony Playstation 4</name>
                <alias>sony-playstation-4</alias>
              </Platform>
              <Platform>
                <id>39</id>
                <name>Sony Playstation Vita</name>
                <alias>sony-playstation-vita</alias>
              </Platform>
              <Platform>
                <id>13</id>
                <name>Sony PSP</name>
                <alias>sony-psp</alias>
              </Platform>
              <Platform>
                <id>6</id>
                <name>Super Nintendo (SNES)</name>
                <alias>super-nintendo-snes</alias>
              </Platform>
              <Platform>
                <id>34</id>
                <name>TurboGrafx 16</name>
                <alias>turbografx-16</alias>
              </Platform>
              <Platform>
                <id>4925</id>
                <name>WonderSwan</name>
                <alias>wonderswan</alias>
              </Platform>
              <Platform>
                <id>4926</id>
                <name>WonderSwan Color</name>
                <alias>wonderswan-color</alias>
              </Platform>
            </Platforms>
          </Data>
        EOXML
      )
    end

    def self.games_response
      @@games_response ||= Nokogiri::XML(
        <<-EOXML
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
      )
    end

    def self.game_response
      @@game_response ||= Nokogiri::XML(
        <<-EOXML
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
      )
    end
  end
end
