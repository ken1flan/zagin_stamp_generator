require_relative 'component_image'

class BaseImage < ComponentImage
  def self.image_dir
    File.expand_path('../../images/bases/', __FILE__)
  end
end
