require 'sinatra'
if development? || test?
  require 'pry'
end

get '/' do
  'Hello World!'
end
