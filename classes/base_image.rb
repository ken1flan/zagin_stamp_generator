require_relative 'component_image'

class BaseImage < ComponentImage
  attr_accessor :id, :mirror_copy

  def self.image_dir
    File.expand_path('../../images/bases/', __FILE__)
  end

  def initialize(id, mirror_copy)
    @id = id
    @mirror_copy = mirror_copy
  end

  def image
    image = super
    image.flop if mirror_copy
    image
  end
end
