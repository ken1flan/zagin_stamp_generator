require_relative 'component_image'

class PatternImage < ComponentImage
  attr_accessor :id

  def self.image_dir
    File.expand_path('../../images/patterns/', __FILE__)
  end
end
