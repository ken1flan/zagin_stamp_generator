require 'yaml'
require 'sinatra'
require 'haml'
require 'mini_magick'
require 'kittenizer'
require_relative 'classes/image_history_repo'
require_relative 'classes/image_history'
require_relative 'classes/base_image'

if development?
  require "sinatra/reloader" if development?
  require 'pry'
  require 'dotenv'
  Dotenv.load
end

base_images = []
File.open('images.yml') do |file|
  YAML.load(file.read).each do |data|
    base_images << BaseImage.new(data)
  end
end

rom = ROM.container(:sql, "#{ENV['DATABASE_URL']}")
image_history_repo = ImageHistoryRepo.new(rom)

get '/form' do
  @url_root =  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
  @base_image_names = base_images.map{|i| i.id}
  @font_names = BaseImage::FONT_PATHS.keys
  @patterns = BaseImage::PATTERN_PATHS.keys
  @sizes = BaseImage::SIZES.keys
  haml :form
end

get '/save_params' do
  image_history_repo.create(
    image_name: params[:image_name],
    text: params[:text],
    font_name: params[:font_name],
    pattern: params[:pattern],
    size: params[:size],
  )
end

get '/?:image_name?' do
  font_name = params[:font_name]

  base_image_information = base_images.find {|i| i.id == params[:image_name]}
  base_image_information ||= base_images.find {|i| i.id == "top"}

  text = params[:text]
  text ||= 'Zagin Stamp\nGenerator'
  base_image_information.text = text
  base_image_information.font_name = font_name

  base_image_information.pattern_name = params[:pattern]
  composite_image = base_image_information.composite

  size = BaseImage::SIZES[params[:size] ? params[:size].to_sym : :Large]
  composite_image.resize "#{size[:width]}x#{size[:height]}"

  composite_image.format "png"
  content_type 'image/png'
  send_file composite_image.path
end

def valid_image_name?(image_name)
  File.exist?("images/bases/#{image_name}.png")
end
