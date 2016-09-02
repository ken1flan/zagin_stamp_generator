require 'rack/test'
require 'rspec'
require_relative '../classes/pattern_image'

ENV['RACK_ENV'] = 'test'

# TODO: Use web.rb
# require File.expand_path '../../web.rb', __FILE__
require File.expand_path '../../web_test.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

RSpec.configure {|c| c.include RSpecMixin }
