require 'sinatra'
require 'mini_magick'
require 'kittenizer'

get '/' do
  font_size = params[:font_size].to_i
  font_size = 30 if font_size <= 0
  text = params[:text]
  text ||= 'Zagin Stamp\nGenerator'
  text.kittenize!
  image = MiniMagick::Image.open('images/top.png')
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
