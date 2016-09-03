class ComponentImage
  require 'mini_magick'

  attr_accessor :id

  def self.image_dir
    raise "Must override method :image_dir"
  end

  def initialize(id)
    @id = id
  end

  def path
    "#{self.class.image_dir}/#{id}.png"
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
    File.exist?("#{self.image_dir}/#{id}.png")
  end

  def self.invalid?(id)
    !self.valid?(id)
  end
end
