require_relative 'component_image'

class PatternImage < ComponentImage
  def self.image_dir
    File.expand_path('../../images/patterns/', __FILE__)
  end
end
