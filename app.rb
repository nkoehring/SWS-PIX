#!/usr/bin/ruby
# encoding: UTF-8

require "haml"
require "sass"
require "sinatra"

get "*.css" do
  sass params[:splat].join('/').to_sym
end

get "*.js" do
  coffee params[:splat].join('/').to_sym
end

get "/" do
  @media = Dir['./public/media/*o.png'].collect{|p| p.split('/')[-1]}.sort
  haml :index
end


