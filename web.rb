require 'yaml'
require 'sinatra'
require 'haml'
require 'mini_magick'
require 'kittenizer'
require_relative 'classes/stamp'
require_relative 'classes/comic'

if development?
  require "sinatra/reloader" if development?
  require 'pry'
  require 'dotenv'
  Dotenv.load
end

Color.load(File.expand_path("../colors.yml", __FILE__))
Stamp.load(File.expand_path("../stamps.yml", __FILE__))

get '/favicon.ico' do
  stamp = Stamp.create_by_id('top')
  stamp.text = 'Zagin Stamp\nGenerator'
  stamp.text_color = 'white'

  stamp_image = stamp.image
  stamp_image.format "png"
  content_type 'image/png'
  send_file stamp_image.path
end

get '/form' do
  @url_root =  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
  @text_colors = Color.list.keys
  @base_image_names = Stamp.list.keys
  @font_names = Stamp::FONT_PATHS.keys
  @patterns = Stamp::PATTERN_PATHS.keys
  @sizes = Stamp::SIZES.keys
  haml :form
end

get '/comic' do
  panel_attributes = {}
  params[:frames].each do |id, params|
    panel_attributes[id] = {
      image_name: params[:image_name],
      mirror_copy: params[:mirror_copy] == 'yes' ? true : false,
      text: params[:text],
      text_color: params[:text_color],
      font_name: params[:font_name],
      pattern: params[:pattern]
    }
  end

  comic_image = Comic.new(
    title: params[:title],
    panel_attributes: panel_attributes
  ).image

  comic_image.format "png"
  content_type 'image/png'
  send_file comic_image.path
end

get '/comic/form' do
  @url_root =  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}"
  @base_image_names = Stamp.list.keys
  @text_colors = Color.list.keys
  @font_names = Stamp::FONT_PATHS.keys
  @patterns = Stamp::PATTERN_PATHS.keys
  @sizes = Stamp::SIZES.keys
  haml :'comic/form'
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

  stamp = Stamp.create_by_id(params[:image_name])
  stamp.mirror_copy = true if params[:mirror_copy] == 'yes'

  text = params[:text]
  text ||= 'Zagin Stamp\nGenerator'
  stamp.text = text
  stamp.text_color = !!params[:text_color] ? params[:text_color] : "white"
  stamp.font_name = font_name

  stamp.pattern_name = params[:pattern]
  stamp_image = stamp.image

  size = Stamp::SIZES[params[:size] ? params[:size].to_sym : :Large]
  stamp_image.resize "#{size[:width]}x#{size[:height]}"

  stamp_image.format "png"
  content_type 'image/png'
  send_file stamp_image.path
end

def valid_image_name?(image_name)
  File.exist?("images/bases/#{image_name}.png")
end
