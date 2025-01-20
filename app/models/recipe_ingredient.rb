class RecipeIngredient < ApplicationRecord
  belongs_to :recipe

  validates :ingredient, presence: true
end
