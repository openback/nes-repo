class Game
  def initialize data
    data[:version] = data[:version] || 1
    [
      :crc,
      :description,
      :name,
      :maintainer,
      :md5,
      :sha1,
      :version,
    ].each do |name|
      instance_variable_set "@#{name}", data[name]
    end
  end

  def sha1? sha1
    @sha1 == sha1
  end

  def md5? md5
    @md5 == md5
  end

  def crc? crc
    @crc == crc
  end

  def to_debian_control
    {
      :package      => @name.downcase.gsub(/(\s|\-+)/,'-').gsub(/[^\w-]/, '') + "-nes",
      :version      => @version ,
      :architecture => 'all',
      :maintainer   => @maintainer,
      :section      => 'games',
      :priority     => 'optional',
      :description  => @description
    }.map do |key, val|
      "#{key.to_s.capitalize}: #{val}"
    end.join("\n")
  end
end
