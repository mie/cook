require ::File.join( ::File.dirname(__FILE__), 'app' )

#enable :logging
set :environment, :development
set :port, 9393
run Cook.new