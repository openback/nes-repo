require 'cgi'
require 'open-uri'

# TODO: Cache the API calls
class GamesDB
  BASE_URL = 'http://thegamesdb.net/api/'
  PLATFORMS_ENDPOINT = 'GetPlatformsList.php'
  GAME_ENDPOINT = 'GetGame.php'
  GAME_LIST_ENDPOINT = 'GetGamesList.php'
  DATE_REGEX = %r_(?<!\d)(\d{1,2})/(\d{1,2})/(\d{4}|\d{2})(?!\d)_

  def self.find(platform, title)
    game_id = nil

    self.get_gameslist(platform, title).css('Game').each do |game|
      if game.search('GameTitle').first.content == title
        game_id = game.search('id').first.content
        break
      end
    end

    raise NotFoundError.new(title) if game_id.nil?
    game = self.get_game game_id

    iso_date = getXMLContent(game, 'Game ReleaseDate').sub(self::DATE_REGEX){|m| "#$3-#$1-#$2"}

    # TODO: Run through and automatically grab everything
    {
      :id           => game_id,
      :release_date => Date.parse(iso_date),
      :overview     => getXMLContent(game, 'Game Overview'),
      :players      => getXMLContent(game, 'Game Players').to_i,
      :coop         => getXMLContent(game, 'Game Co-op') == 'Yes',
      :publisher    => getXMLContent(game, 'Game Publisher'),
      :developer    => getXMLContent(game, 'Game Developer'),
    }
  end

  def self.platforms
    @@platforms ||= {}

    if @@platforms.empty?
      self.query(self::PLATFORMS_ENDPOINT).search('Data Platforms Platform').each do |platform|
        name = self.getXMLContent(platform, 'alias')
        @@platforms[name.gsub(/-/,'_').to_sym] = name
      end
    end

    @@platforms
  end

  private

  def self.get_gameslist(platform, title)
    raise ArgumentError.new("Invalid Platform: `#{platform}'") unless self.platforms.has_key?(platform)
    raise ArgumentError.new("Title cannot be empty") if title.nil? or title.empty?

    self.query(self::GAME_ENDPOINT, {
      :name => title,
      :platform => self.platforms[platform]
    })
  end

  def self.get_game(id)
    self.query(self::GAME_ENDPOINT, { :id => id })
  end

  def self.query(endpoint, params = {})
    Nokogiri::XML(open(self::BASE_URL + endpoint + has_to_querystring(params)))
  end

  def self.getXMLContent(doc, css)
    node = doc.search(css).first
    node.nil? ? '' : node.content
  end

  def self.hash_to_querystring(params = {})
    return '' if params.empty?

    '?' + params.keys.inject('') do |query_string, key|
      query_string << '&' unless key == params.keys.first
      query_string << "#{key}=#{CGI.escape(params[key].to_s)}"
    end
  end

  class NotFoundError < StandardError
    def initialize(title)
      super("`#{title}' was not found")
    end
  end
end
