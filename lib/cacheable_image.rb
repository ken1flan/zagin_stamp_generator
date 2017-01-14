require 'dalli'
require 'mini_magick'

module CacheableImage
  @@cache_client = nil

  def image_ext
    raise "Must override method :image_ext"
  end

  def cache_key
    raise "Must override method :cache_key"
  end

  def load_image_from_cache
    return nil unless CacheableImage.cache_client

    cached_data = CacheableImage.cache_client.get(cache_key)
    if cached_data
      MiniMagick::Image.read(cached_data, image_ext)
    else
      nil
    end
  end

  def save_to_cache(image)
    cache_client = CacheableImage.cache_client
    if cache_client
      cache_client.set(cache_key, image.to_blob)
    end
    image
  end

  def self.cache_client
    return @@cache_client if @@cache_client

    cache_server = ENV['CACHE_SERVER']
    return nil unless cache_server

    @@cache_client = Dalli::Client.new(ENV["CACHE_SERVER"])
    @@cache_client
  end
end
