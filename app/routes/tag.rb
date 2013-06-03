class Cook < Sinatra::Application

  get '/api/random_tags' do
    content_type :json

    tags = Tag.where(:random.gt => rand).limit(3)
    unless tags == []
      status 200
      body(({:tags => tags.map {|t| t.as_hash }}).to_json)
    else
      status 404
    end
  end

end