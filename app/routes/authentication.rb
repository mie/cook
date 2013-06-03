class Cook < Sinatra::Application

  # --------------
  # Authentication
  # --------------

  post '/api/signin' do
    content_type :json

    data = request.body.read
    jd = JSON.parse(data)
    if jd['email'] && jd['password']
      users = User.where({email: jd['email']})
        unless users == []
          user = users.first
          if user.password == BCrypt::Engine.hash_secret(jd['password'], user.salt)
            p 'here'
            session[:user_id] = user._id.to_s
            json_status 200, "OK"
          else
            json_status 404, "No user found"
          end
      end
    else
      json_status 404, "No user found"
    end
  end

  delete "/api/signout" do
    if current_user
      session.clear
      json_status 200, "OK"
    else
      json_status 401, "Not authorized"
    end
  end

end