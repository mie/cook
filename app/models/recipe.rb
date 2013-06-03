class Recipe
  include Mongoid::Document
  include Mongoid::Pagination   

    field :title, type: String
    field :intro, type: String
    field :minutes, type: Integer
    field :servings, type: Integer
    field :description, type: String
    field :deleted, type: Boolean
    field :created_at, type: DateTime
    field :random, type: Float
    field :likes_count, type: Integer

    belongs_to :user, :inverse_of => :posts
    embeds_many :ingredients
    #embeds_many :media
    has_and_belongs_to_many :tags
    has_and_belongs_to_many :likes, :class_name => 'User', :inverse_of => :liked, autosave: true
    #has_many :reactions

    before_create :generate_random

    validates :user, :presence => true, :allow_blank => false
    validates :title, :presence => true, :allow_blank => false
    validates :intro, :presence => true, :allow_blank => false
    validates :minutes, :presence => true
    validates :servings, :presence => true
    validates :description, :presence => true, :allow_blank => false


  def as_hash
    return {
      :id => self._id.to_s,
      :intro => self.intro,
      :title => self.title,
      :minutes => self.minutes,
      :servings => self.servings,
      :description => self.description,
      :user => self.user.as_hash,
      :tags => self.tags.map {|t| t.as_hash },
      :ingredients => self.ingredients.map {|i| i.as_hash },
      :likes => self.likes.count,
      :created_at => self.created_at
    }
  end

  def as_short_hash
    return {
      :id => self._id.to_s,
      :intro => self.intro,
      :title => self.title,
      :minutes => self.minutes,
      :servings => self.servings,
      :user => self.user.as_hash,
      :tags => self.tags.map {|t| t.as_hash },
      :likes => self.likes.count,
      :created_at => self.created_at
    }
  end

  def delete_self
    self.deleted = true
    self.user.recipes_count -= 1
    self.user.save
    self.tags.each{|t| t.recipes_count -= 1; t.save }
  end

  protected
    
    def generate_random
      self.random = rand
    end

end