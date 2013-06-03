class User
  include Mongoid::Document
  include Mongoid::Pagination
    
  field :username, type: String
  field :realname, type: String
  field :password, type: String
  field :salt, type: String
  field :email, type: String
  field :avatar, type: String
  field :disabled, type: Boolean
  field :reg_complete, type: Boolean
  field :created_at, type: DateTime
  field :recipes_count, type: Integer

  has_many :recipes, :inverse_of => :user
  has_many :tags

  has_and_belongs_to_many :liked, :class_name => 'Recipe', :inverse_of => :likes, autosave: true

  has_and_belongs_to_many :following, class_name: 'User', inverse_of: :followers, autosave: true
  has_and_belongs_to_many :followers, class_name: 'User', inverse_of: :following

  validates :username, :presence => true, :length => { :minimum => 3, :maximum => 20, :allow_blank => false }, uniqueness: true
  validates :realname, :presence => true, :length => { :minimum => 3, :maximum => 64, :allow_blank => false }
  validates :password, :presence => true, :allow_blank => false
  validates :salt, :presence => true, :allow_blank => false
  validates :email, :presence => true, :length => { :minimum => 6, :maximum => 96, :allow_blank => false }, uniqueness: true

  def like!(recipe)
    if !self.liked.include?(recipe)
      self.liked << recipe
      recipe.likes_count += 1
      recipe.save
    end
  end

  def dislike!(recipe)
    if !self.recipes.include?(recipe) && self.liked.include?(recipe)
      self.liked.delete(recipe)
      recipe.likes_count -= 1
    end
  end

  def follow!(user)
    if self.id != user.id && !self.following.include?(user)
      self.following << user
    end
  end

  def unfollow!(user)
    self.following.delete(user) if self.following.include?(user)
  end

  def follow_tag!(tag)
    unless self.tags.include?(tag)
      self.add_tags(tag)
    end
  end

  def as_hash
    return {
      :id => self._id.to_s,
      :username => self.username,
      :realname => self.realname,
      :avatar => self.avatar,
      :created_at => self.created_at
    }
  end

end