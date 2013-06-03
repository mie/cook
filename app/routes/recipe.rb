class Cook < Sinatra::Application

  # ------------------
  # REST API for recipes
  # ------------------

  get '/api/popular/?', :provides => :json do
    content_type :json

    page = params['page_number'] || 1
    period = params['period'] || 'today'
    tm = Time.now
    case period
    when 'today'
      tm = Time.now - 60*60*24
    when 'week'
      tm = Time.now - 60*60*24*7
    when 'month'
      tm = Time.now - 60*60*24*30
    when 'alltime'
      tm = Time.at(0)
    end
    Recipe.where(:deleted => false, :created_at.gte => (Time.now - 60*60*24)).desc(:likes_count)
    unless recipes == []
      status 200
      body( ( { :recipes => recipes.map do |r| r.as_short_hash end } ).to_json )
    else
      json_status 404, "Not found"
    end
  end

  get '/api/recipes/?', :provides => :json do
    content_type :json

    page = params['page_number'] || 1
    short = params['short']
    recipes = Recipe.where(deleted: false).paginate(:page => page, :limit => 10).desc(:_id)
    unless recipes == []
      status 200
      body( ( { :recipes => recipes.map do |r| r.as_short_hash end } ).to_json )
    else
      json_status 404, "Not found"
    end
  end

  get '/api/recipes_by_tag/?', :provides => :json do
    content_type :json

    page = params['page_number'] || 1
    tag = params['tag']
    tags = Tag.where(tag_name: tag)
    unless tags == [] || !tags.first.has_recipes?
      status 200
      recipes = tag.first.recipes.paginate(:page => page, :limit => 10).desc(:_id)
      body( ( { :recipes => recipes.map do |r| r.as_short_hash end } ).to_json )
    else
      status 404
    end
  end

  get "/api/recipes/:id", :provides => :json do
    content_type :json

    recipes = Recipe.where(_id: params['id'], deleted: false)
    unless recipes == []
      recipe = recipes.first
      status 200
      body(
        recipe.to_json
      )
    else
      json_status 404, "Not found"
    end
  end
######

  # post "/api/like_recipe" do
  #   if current_user
  #     content_type :json

  #     data = request.body.read
  #     jd = JSON.parse(data)
  #     if jd['recipe_id'] 
  #       recipes = Recipe.where(_id: jd['recipe_id'])
  #       unless recipes == []
  #         recipe = recipes.first
  #         recipe.likes += 1
  #         recipe.save
  #       else
  #         json_status 400, "Bad request_"
  #       end
  #     else
  #       json_status 400, "Bad request"
  #     end
  #   else
  #     json_status 401, "Unauthorized"
  #   end
  # end

  post "/api/recipes/?", :provides => :json do
    if current_user
      content_type :json

      data = request.body.read
      jd = JSON.parse(data)
      if ['title', 'description', 'servings', 'minutes', 'intro', 'tags', 'ingredients'].all? {|o| jd.include? o}
        recipe = Recipe.new(Hash[*jd.select {|k,v| ['title', 'description', 'servings', 'minutes', 'intro'].include?(k)}.flatten])
        current_user.recipes << recipe
        jd['tags'].each do |tag|
          t = Tag.find_or_create_by(tag_name: tag, url_name: tag)
          t.recipes_count = 1
          recipe.tags << t
          #recipe.tags << Tag.where(tag_name: jd['tag']).first unless Tag.where(tag_name: jd['tag']) == []
        end
        jd['ingredients'].each do |i|
          recipe.ingredients << Ingredient.new(ing_name: i['ingredient'], quantity: i['quantity'])
        end
        recipe.created_at = Time.now
        recipe.deleted = false
        recipe.likes_count = 0
        if recipe.save
          current_user.like!(recipe)
          current_user.save
          status 201
          body(
            JSON.generate({
              :recipe_id => recipe._id.to_s
            })
          )
        else
          json_status 400, "Bad request_"
        end
      else
        json_status 400, "Bad request"
      end
    else
      json_status 401, "Unauthorized"
    end
  end

  put "/api/recipes/:id", :provides => :json do
    if current_user
      content_type :json

      data = request.body.read
      jd = JSON.parse(data)
      new_params = Hash[*jd.select {|k,v| ['title', 'description', 'servings', 'minutes', 'intro', 'tags', 'ingredients', 'likes'].include?(k)}.flatten]
      recipes = Recipe.where({_id: params[:id], user_id: current_user.id})
      unless recipes == [] || new_params == {}
        recipe = recipes.first
        recipe.update_attributes(new_params)
        recipe.likes = recipe.likes + 1 if jd['likes']
        jd['tags'].each do |tag|
          recipe.tags << Tag.where(tag_name: jd['tag']).first unless Tag.where(tag_name: jd['tag']) == []
        end if jd['tags']
        jd['ingredients'].each do |ing|
          recipe.ingredients << Ingredient.find_or_create_by({ing_name: jd['ingredients']['ing_name'], }).first unless Tag.where(tag_name: jd['tag']) == []
        end if jd['tags']
        jd['likes'].each do |l|
          if jd['likes'] == '1'
            current_user.like!(recipe)
          else
            current_user.dislike!(recipe)
          end
        end if jd['likes']
        if recipe.save
          status 200
          recipe.to_json
        else
          json_status 400, "Bad request_"
        end
      else
        json_status 404, "Not found"
      end
    else
      json_status 401, "Unauthorized"
    end
  end

  delete "/api/recipes/:id/?", :provides => :json do
    if current_user
      content_type :json

      recipes = Recipe.where(_id: params[:id], user_id: current_user._id)
      unless recipes == []
        recipe = recipes.first
        recipe.delete_self
        recipe.save
        current_user.save
        json_status 204, "No content"
      else
        json_status 404, "Not found"
      end
    else
      json_status 401, "Unauthorized"
    end
  end

end