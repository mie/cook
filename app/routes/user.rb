class Cook < Sinatra::Application

  # ------------------
  # REST API for users
  # ------------------

  get '/api/users', :provides => :json do
    content_type 'application/json'

    page = params['page_number'] || 1
    users = User.only(:username, :realname, :avatar, :created_at).paginate(:page => page, :limit => 10).desc(:_id)
    status 200
    body(
      JSON.generate( 
        {:users => users.map { |u| 
          {
            :id => u._id.to_s,
            :username => u.username,
            :realname => u.realname,
            :avatar => u.avatar,
            :created_at => u.created_at
          }
        }
      })
    )
  end  

  get "/api/users/:id", :provides => :json do
    content_type 'application/json'

    users = User.only(:username, :realname, :avatar, :created_at).where(_id: params[:id])
    unless users == []
      user = users.first
      status 200
      body(
        JSON.generate({
          :id => user._id.to_s,
          :username => user.username,
          :realname => user.realname,
          :avatar => user.avatar,
          :created_at => user.created_at
        })
      )
    else
      json_status 404, "Not found"
    end
  end

  post "/api/users/?", :provides => :json do
    content_type 'application/json'

    data = request.body.read
    jd = JSON.parse(data)
    if ['username', 'realname', 'password', 'email', 'avatar'].all? {|o| jd.include? o}
      users = User.any_of({email: jd['email']}, {username: jd['username']})
      if users.count == 0
        user = User.new(Hash[*jd.select {|k,v| ['username', 'realname', 'email', 'avatar'].include?(k)}.flatten])
        user.salt = BCrypt::Engine.generate_salt
        user.password = BCrypt::Engine.hash_secret(jd['password'], user.salt)
        user.reg_complete = true
        user.disabled = false
        user.recipes_count = 0
        if user.save
          status 201
          body(
            JSON.generate({:user_id => user._id.to_s})
          )
        else
          json_status 400, "Bad request_"
        end
      else
        json_status 404, "Not found"
      end
    else
      json_status 400, "Bad request"
    end
  end

  put "/api/users/:id", :provides => :json do
    if current_user
      content_type 'application/json'

      data = request.body.read
      jd = JSON.parse(data)
      new_params = Hash[*jd.select {|k,v| ['realname', 'password', 'email'].include?(k)}.flatten]
      users = User.where(_id: params[:id])
      unless users == [] || new_params == {}
        unless new_params['email'] && User.where(email: new_params['email']) != []
          user.update_attributes(new_params)
          if user.save
            status 200
            body(
              JSON.generate({
                :id => user._id.to_s,
                :username => user.username,
                :realname => user.realname,
                :avatar => user.avatar,
                :created_at => user.created_at
              })
            )
          else
            json_status 400, "Bad request_"
          end
        else
          json_status 400, "Bad request"
        end
      else
        json_status 404, "Not found"
      end
    else
      json_status 401, "Not authorized"
    end
  end

  delete "/api/users/:id/?", :provides => :json do
    if current_user && current_user == User.where(_id: params[:id]).first
      content_type 'application/json'

      current_user.deleted = true
      session.clear
      if current_user.save
        json_status 204, "No content"
      else
        json_status 400, "Bad request_"
      end
    else
      json_status 401, "Not authorized"
    end
  end

end