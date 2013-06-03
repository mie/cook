require "json/ext"
require "mongoid"
require "mongoid-pagination"
require "sinatra"
#require "sinatra/accept_params"
require 'sinatra/cross_origin'
require "slim"
require "bcrypt"
require "securerandom"

class Cook < Sinatra::Application

  if defined? Encoding
    Encoding.default_external = Encoding::UTF_8
    Encoding.default_internal = Encoding::UTF_8
  end

  # MongoDB config
  # user - chief
  # pass - ddeHhNrk5W3JMsYb5NrU

  configure :production do
    Mongoid.load!('./config/mongoid.yml', :production)
  end

  configure :development do
    Mongoid.load!('./config/mongoid.yml', :development)
  end

  ingredients = {}
  caches = Dir.glob("ingredients-*.save").sort {|a,b| File.mtime(b) <=> File.mtime(a)}
  File.open(caches[0]) { |f|
    ingredients = Marshal.load(f)
  } if caches != []

  configure do
    set :root, File.dirname(__FILE__)
    set :app_file, __FILE__
    set :default_encoding, 'utf-8'
    set :static, true
    enable :sessions
    set :session_secret, 'a02d830cf85a1428da8434de3cc894'
    set :ingredients, ingredients.keys
  end

end

Dir[File.join(File.dirname(__FILE__), "app", "**", "init.rb")].each do |file|
  require file
end
