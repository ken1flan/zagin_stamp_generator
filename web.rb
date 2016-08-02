require 'sinatra'
require 'haml'
require 'mini_magick'
require 'kittenizer'

BASE_IMAGE_PATHS = {
  'happi_coat': 'images/happi_coat.png',
  'thumbup': 'images/thumbup.png',
}
FONT_DEFAULT = :noto
FONT_PATHS = {
  noto: 'fonts/NotoSansCJKjp-Black.otf',
  kei: 'fonts/keifont.ttf',
}
PATTERN_PATHS = {
  white: 'images/patterns/white.png',
  tora: 'images/patterns/tora.png',
  mike: 'images/patterns/mike.png',
}

get '/form' do
  @url_root =  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
  @base_image_names = BASE_IMAGE_PATHS.keys
  @font_names = FONT_PATHS.keys
  @patterns = PATTERN_PATHS.keys
  haml :form
end

get '/?:image_name?' do
  font_name = params[:font_name]

  text = params[:text]
  text ||= 'Zagin Stamp\nGenerator'
  text.kittenize!
  text_image = create_text_image(text, font_name: font_name)

  image_name = valid_image_name?(params[:image_name]) ? params[:image_name] : 'top'
  base_image = MiniMagick::Image.open("images/#{image_name}.png")
  base_image.resize "300x300"

  pattern_image = pattern_image(params[:pattern])
  composite_image = pattern_image.composite(base_image) do |c|
    c.compose "Over"
  end

  composite_image = composite_image.composite(text_image) do |c|
    c.compose "Over"
    c.gravity 'South'
  end

  composite_image.format "png"
  content_type 'image/png'
  send_file composite_image.path
end

def valid_image_name?(image_name)
  File.exist?("images/#{image_name}.png")
end

def pattern_image(pattern_name)
  pattern_name = "white" unless File.exist?("images/patterns/#{pattern_name}.png")
  MiniMagick::Image.open("images/patterns/#{pattern_name}.png")
end

def create_text_image(text, font_name: FONT_DEFAULT)
  font_name = FONT_DEFAULT unless font_name && FONT_PATHS.keys.include?(font_name.to_sym)

  font_size = 30
  text_image = MiniMagick::Image.open('images/text_base.png')
  text_image.combine_options do |c|
    c.gravity 'North'
    c.pointsize font_size
    c.font FONT_PATHS[font_name.to_sym]
    c.fill 'white'
    c.annotate '0,0', text
    c.stroke 'black'
  end
  text_image.trim
  text_image.resize "300x300"
end
