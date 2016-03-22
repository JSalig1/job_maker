require 'sinatra'

get "/#{ENV['SUB_DIR']}/" do
  erb :index
end
