class Game
  def initialize(name, description, maintainer, version=1)
    @name, @description, @maintainer, @version = name, description, maintainer, version
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
