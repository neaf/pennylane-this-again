class Recipe < ApplicationRecord
  belongs_to :category, class_name: "RecipeCategory", foreign_key: :recipe_category_id, required: false
  has_many :ingredients, class_name: "RecipeIngredient", dependent: :destroy
end
