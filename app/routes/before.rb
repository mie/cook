class Cook < Sinatra::Application

  ['', 'signup', 'new_recipe'].each do |link|
    get '/'+link do
      unless link == ''
        slim link.to_sym
      else
        slim :recipes
      end
    end
  end

  get '/ingredients.json' do
    content_type :json
    status 200
    body({:ingredients => settings.ingredients }.to_json)
  end

  # get '/' do
  #   #File.read('public/index.html')
  #   slim :index
  # end

  # get '/signup' do
  #   slim :signup
  # end

  get '/tag/:tag' do
    tags = Tag.where(tag_name: params['tag'])
    unless tags == [] || !tags.first.has_recipes?
      slim :recipes
      #tag = tags.first
      #recipes = Recipe.where({'tags.tag_name' => tag.tag_tame})
    else
      status 404
    end
  end

  get '/recipe/:rid' do
    recipes = Recipe.where(_id: params['rid'])
    unless recipes == []
      recipe = recipes.first
      slim :recipe, :locals => {:recipe => recipe, :author => recipe.user}
    else
      status 404
    end
  end

  get '/user/:uid' do
    user = User.where(_id: params['uid'])
    unless users == []
      user = users.first
      slim :user, :locals => {:user => user, :recipes => user.recipes}
    else
      status 404
    end
  end

end