module Datfile
  class Game
    attr_accessor	:name,
      :group_name,
      :group,
      :description,
      :size,
      :crc,
      :md5,
      :sha1
    attr_writer		:games
  end
end


