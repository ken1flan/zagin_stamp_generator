require 'sinatra'
require 'mini_magick'
require 'kittenizer'

get '/?:image_name?' do
  font_size = params[:font_size].to_i
  font_size = 30 if font_size <= 0
  text = params[:text]
  text ||= 'Zagin Stamp\nGenerator'
  text.kittenize!
  image_name = valid_image_name?(params[:image_name]) ? params[:image_name] : 'top'
  image = MiniMagick::Image.open("images/#{image_name}.png")
  image.resize "300x300"
  image.combine_options do |c|
    c.gravity 'South'
    c.pointsize font_size
    c.font 'fonts/NotoSansCJKjp-Black.otf'
    c.fill 'white'
    c.annotate '0,0', text
    c.stroke 'black'
  end

  image.format "png"
  content_type 'image/png'
  send_file image.path
end

def valid_image_name?(image_name)
  File.exist?("images/#{image_name}.png")
end
