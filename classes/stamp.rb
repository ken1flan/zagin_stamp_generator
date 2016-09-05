class Stamp
  require 'mini_magick'
  require 'kittenizer'
  require_relative 'pattern_image'
  require_relative 'text_image'

  attr_accessor :id, :name, :text, :font_name, :textbox_x, :textbox_y, :textbox_w, :textbox_h, :textbox_angle, :pattern_name

  FONT_DEFAULT = :"NotoSansCJKjp-Black"
  FONT_PATHS = {
    "NotoSansCJKjp-Black": 'fonts/NotoSansCJKjp-Black.otf',
    "keifont": 'fonts/keifont.ttf',
  }
  PATTERN_DEFAULT = :white
  PATTERN_PATHS = {
    white: 'images/patterns/white.png',
    zagin: 'images/patterns/zagin.png',
    tora: 'images/patterns/tora.png',
    mike: 'images/patterns/mike.png',
  }
  SIZES = {
    Large: {height: 300, width: 300},
    Middle: {height: 150, width: 150},
    Small: {height: 75, width: 75},
  }

  def initialize(id: nil, name: nil, font_name: FONT_DEFAULT, textbox_x: 0, textbox_y: 0, textbox_w: 300, textbox_h: 300, textbox_angle: 0, pattern_name: PATTERN_DEFAULT )
    self.id = id
    self.name = name
    self.textbox_x = textbox_x
    self.textbox_y = textbox_y
    self.textbox_w = textbox_w
    self.textbox_h = textbox_h
    self.textbox_angle = textbox_angle
  end

  def base_image
    unless @base_image
      @base_image = MiniMagick::Image.open("images/bases/#{id}.png")
    end
    @base_image.resize "300x300"
    @base_image
  end

  def text_image
    fix_font_name = font_name
    fix_font_name = FONT_DEFAULT unless font_name && FONT_PATHS.keys.include?(font_name.to_sym)

    text_image = TextImage.new(text: text, font_name: fix_font_name, width: textbox_w, height: textbox_h)
    text_image.image
  end

  def pattern_image
    pattern_image = PatternImage.new(PatternImage.valid?(pattern_name) ? pattern_name : PATTERN_DEFAULT)
    pattern_image.image
  end

  def composite
    composite_image = pattern_image.composite(base_image) do |c|
      c.compose "Over"
    end

    composite_image = composite_image.composite(text_image) do |c|
      c.compose "Over"
      c.geometry "+#{textbox_x}+#{textbox_y}"
      c.gravity 'NorthWest'
    end
    composite_image
  end
end
