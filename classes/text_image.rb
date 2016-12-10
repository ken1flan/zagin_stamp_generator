require 'mini_magick'
require 'kittenizer'

class TextImage
  attr_accessor :text, :font_name, :width, :height, :kittenize

  BASE_IMAGE = File.expand_path('../../images/text_base.png', __FILE__)
  FONT_DIR = File.expand_path('../../fonts', __FILE__)
  FONT_SISE = 50

  def initialize(text: "LGTM!", font_name: "NotoSansCJKjp-Black", width: 280, height: 280, kittenize: true)
    @text = text
    @font_name = font_name
    @width = width
    @height = height
    @kittenize = kittenize
  end

  def kittenize?
    !!@kittenize
  end

  def font_path
    files = Dir.glob("#{FONT_DIR}/#{font_name}.*")
    files.first
  end

  def image
    image = MiniMagick::Image.open(BASE_IMAGE)
    image.combine_options do |c|
      c.gravity 'North'
      c.pointsize FONT_SISE
      c.font font_path
      c.fill 'white'
      c.annotate '0,0', kittenize? ? text.kittenize : text
      c.stroke 'black'
    end
    image.trim
    image.resize "#{width}x#{height}"
    image.combine_options do |c|
      c.background 'None'
      c.gravity "center"
      c.extent "#{width}x#{height}"
    end
  end

  def self.valid_font_name?(font_name)
    files = Dir.glob("#{FONT_DIR}/#{font_name}.*")
    !files.first.nil?
  end

  def self.invalid_font_name?(font_name)
    !self.valid_font_name?(font_name)
  end
end
