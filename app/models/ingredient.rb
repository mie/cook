class Ingredient
  include Mongoid::Document
    
    field :ing_name, type: String
    field :quantity, type: String

    embedded_in :recipe

  def as_hash
    return {
      :id => self._id.to_s,
      :ing_name => self.ing_name,
      :quantity => self.quantity
    }
  end


end