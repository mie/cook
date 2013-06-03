# encoding: utf-8
class Cook < Sinatra::Application

  get "*" do
    status 404
  end

  post "*" do
    status 404
  end

  delete "*" do
    status 404
  end

  not_found do
    json_status 404, "Not found"
  end

  error do
    json_status 500, env['sinatra.error'].message
  end

end