require 'mini_magick'
require 'kittenizer'
require_relative 'color'

class TextImage
  attr_accessor :text, :fill_color_id, :font_name, :width, :height, :kittenize

  BASE_IMAGE = File.expand_path('../../images/text_base.png', __FILE__)
  FONT_DIR = File.expand_path('../../fonts', __FILE__)
  FONT_SISE = 50
  DEFAULT_FILL_COLOR_ID = 'white'
  DEFAULT_STROKE_COLOR_ID = 'black'
  OTHER_STROKE_COLOR_ID = 'white'

  def initialize(text: "LGTM!", fill_color_id: "white", font_name: "NotoSansCJKjp-Black", width: 280, height: 280, kittenize: true)
    @text = text
    @fill_color_id = fill_color_id
    @font_name = font_name
    @width = width
    @height = height
    @kittenize = kittenize
  end

  def fill_color
    color = Color.find_by_id(fill_color_id)
    color
  end

  def stroke_color
    stroke_color_id = fill_color_id == DEFAULT_FILL_COLOR_ID ? DEFAULT_STROKE_COLOR_ID : OTHER_STROKE_COLOR_ID
    color = Color.find_by_id(stroke_color_id)
    color
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
      c.fill fill_color.code
      c.annotate '0,0', kittenize? ? text.kittenize : text
      c.stroke stroke_color.code
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
