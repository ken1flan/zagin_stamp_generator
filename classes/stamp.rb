class Stamp
  require 'mini_magick'
  require 'kittenizer'
  require_relative 'base_image'
  require_relative 'pattern_image'
  require_relative 'text_image'
  require_relative '../lib/cacheable_image'

  include CacheableImage

  attr_accessor :id, :name, :mirror_copy, :text, :text_color, :font_name, :textbox_x, :textbox_y, :textbox_w, :textbox_h, :textbox_angle, :pattern_name

  FONT_DEFAULT = :"NotoSansCJKjp-Black"
  FONT_PATHS = {
    "NotoSansCJKjp-Black": 'fonts/NotoSansCJKjp-Black.otf',
    "keifont": 'fonts/keifont.ttf',
  }
  PATTERN_DEFAULT = :white
  PATTERN_PATHS = {
    white: 'images/patterns/white.png',
    darkgray: 'images/patterns/darkgray.png',
    moccasin: 'images/patterns/moccasin.png',
    royalblue: 'images/patterns/royalblue.png',
    zagin: 'images/patterns/zagin.png',
    tora: 'images/patterns/tora.png',
    mike: 'images/patterns/mike.png',
  }
  SIZES = {
    Large: {height: 300, width: 300},
    Middle: {height: 150, width: 150},
    Small: {height: 75, width: 75},
  }

  @@default_data = nil

  def initialize(id: nil, name: nil, text: nil, text_color: nil, mirror_copy: false, font_name: FONT_DEFAULT, textbox_x: 0, textbox_y: 0, textbox_w: 300, textbox_h: 300, textbox_angle: 0, pattern_name: PATTERN_DEFAULT )
    self.id = id
    self.name = name
    self.text = text
    self.text_color = text_color
    self.mirror_copy = mirror_copy
    self.textbox_x = textbox_x
    self.textbox_y = textbox_y
    self.textbox_w = textbox_w
    self.textbox_h = textbox_h
    self.textbox_angle = textbox_angle
  end

  def image_ext
    :png
  end

  def cache_key
    "stamp_#{id}_#{name}_#{text}_#{text_color}_#{mirror_copy}_#{font_name}_#{textbox_x}_#{textbox_y}_#{textbox_w}_#{textbox_h}_#{textbox_angle}_#{pattern_name}"
  end

  def base_image
    base_image = BaseImage.new(id, mirror_copy)
    base_image.image
  end

  def text_image
    fix_font_name = font_name
    fix_font_name = FONT_DEFAULT unless font_name && FONT_PATHS.keys.include?(font_name.to_sym)

    text_image = TextImage.new(text: text, fill_color_id: text_color, font_name: fix_font_name, width: textbox_w, height: textbox_h)
    text_image.image
  end

  def pattern_image
    pattern_image = PatternImage.new(PatternImage.valid?(pattern_name) ? pattern_name : PATTERN_DEFAULT)
    pattern_image.image
  end

  def image
    cached_image = load_image_from_cache
    return cached_image if cached_image

    composite_image = pattern_image.composite(base_image) do |c|
      c.compose "Over"
    end

    composite_image = composite_image.composite(text_image) do |c|
      c.compose "Over"
      c.geometry "+#{textbox_x}+#{textbox_y}"
      c.gravity 'NorthWest'
    end

    save_to_cache(composite_image)
  end

  def self.load(file_path)
    @@default_data = {}
    File.open(file_path) do |file|
      YAML.load(file.read).each do |data|
        @@default_data[data[:id]] = Stamp.new(data)
      end
    end
  end

  def self.reset
    @@default_data = nil
  end

  def self.create_by_id(id)
    raise "doesn't load default data" unless self.setup?

    stamp = @@default_data[id]
    raise "not found #{id}" unless stamp

    stamp.dup
  end

  def self.list
    raise "doesn't load default data" unless self.setup?

    @@default_data
  end

  def self.setup?
    !!@@default_data
  end
end
