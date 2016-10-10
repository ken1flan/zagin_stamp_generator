require 'yaml'
require 'sinatra'
require 'haml'
require 'mini_magick'
require 'kittenizer'
require_relative 'classes/stamp'

if development?
  require "sinatra/reloader" if development?
  require 'pry'
end

stamps = []
File.open('stamps.yml') do |file|
  YAML.load(file.read).each do |data|
    stamps << Stamp.new(data)
  end
end

get '/form' do
  @url_root =  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
  @base_image_names = stamps.map{|i| i.id}.select{|id| id != 'top'}
  @font_names = Stamp::FONT_PATHS.keys
  @patterns = Stamp::PATTERN_PATHS.keys
  @sizes = Stamp::SIZES.keys
  haml :form
end

get '/?:image_name?' do
  font_name = params[:font_name]

  stamp = stamps.find {|i| i.id == params[:image_name]}
  stamp ||= stamps.find {|i| i.id == "top"}

  stamp.mirror_copy = true if params[:mirror_copy] == 'yes'

  text = params[:text]
  text ||= 'Zagin Stamp\nGenerator'
  stamp.text = text
  stamp.font_name = font_name

  stamp.pattern_name = params[:pattern]
  stamp_image = stamp.composite

  size = Stamp::SIZES[params[:size] ? params[:size].to_sym : :Large]
  stamp_image.resize "#{size[:width]}x#{size[:height]}"

  stamp_image.format "png"
  content_type 'image/png'
  send_file stamp_image.path
end

def valid_image_name?(image_name)
  File.exist?("images/bases/#{image_name}.png")
end
