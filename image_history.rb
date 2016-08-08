class ImageHistory
  attr_reader :id, :text, :font_name, :image_name, :pattern
  # attr_accessor :id, :text, :font_name, :image_name, :pattern

  def initialize(attributes)
   @id, @text, @font_name, @image_name, @pattern = attributes(:id, :text, :font_name, :image_name, :pattern)
  end
end
