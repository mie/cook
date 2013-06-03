Dir[File.join(File.dirname(__FILE__), "*.rb")].each do |file|
  require file unless File.basename(file) == 'init.rb'
end

Cook.helpers NiceBytes
Cook.helpers PartialPartials
Cook.helpers Base58

class Cook < Sinatra::Application

  helpers do

    def json_status(code, reason)
      status code
      {
        :status => code,
        :reason => reason
      }.to_json
    end

    def accept_params(params, *fields)
      h = { }
      fields.each do |name|
        h[name] = params[name] if params[name]
      end
      h
    end

    def current_user
      @current_user ||= User.where(_id: session[:user_id]).first if session[:user_id]
    end

  end

end