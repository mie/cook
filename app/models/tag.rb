class Tag
  include Mongoid::Document
    
    field :tag_name, type: String
    field :url_name, type: String
    field :random, type: Float
    field :recipes_count, type: Integer

    has_and_belongs_to_many :recipes
    belongs_to :user

    before_create :generate_random

  def as_hash
    return {
      :id => self._id.to_s,
      :tag_name => self.tag_name,
      :url_name => self.url_name
    }
  end


  protected
    
    def generate_random
      self.random = rand
    end

end