require 'sinatra'
require 'mini_magick'
require 'kittenizer'

get '/?:image_name?' do
  text = params[:text]
  text ||= 'Zagin Stamp\nGenerator'
  text.kittenize!
  text_image = create_text_image(text)

  image_name = valid_image_name?(params[:image_name]) ? params[:image_name] : 'top'
  base_image = MiniMagick::Image.open("images/#{image_name}.png")
  base_image.resize "300x300"

  composite_image = base_image.composite(text_image) do |c|
    c.compose "Over"
    c.gravity 'South'
  end
  composite_image.format "png"
  content_type 'image/png'
  send_file composite_image.path

  composite_image.format "png"
  content_type 'image/png'
  send_file composite_image.path
end

def valid_image_name?(image_name)
  File.exist?("images/#{image_name}.png")
end

def create_text_image(text)
  font_size = 30
  text_image = MiniMagick::Image.open('images/text_base.png')
  text_image.combine_options do |c|
    c.gravity 'North'
    c.pointsize font_size
    c.font 'fonts/NotoSansCJKjp-Black.otf'
    c.fill 'white'
    c.annotate '0,0', text
    c.stroke 'black'
  end
  text_image.trim
end
