class PatternImage
  require 'mini_magick'

  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def path
    image_dir = File.expand_path('../../images/patterns/', __FILE__)
    "#{image_dir}/#{id}.png"
  end

  def valid?
    File.exist?(path)
  end

  def invalid?
    !valid?
  end

  def image
    if valid?
      MiniMagick::Image.open(path)
    else
      nil
    end
  end

  def self.valid?(id)
    File.exist?("images/patterns/#{id}.png")
  end

  def self.invalid?(id)
    !self.valid?(id)
  end
end
