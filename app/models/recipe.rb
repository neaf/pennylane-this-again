class Recipe < ApplicationRecord
  belongs_to :category, class_name: "RecipeCategory", foreign_key: :recipe_category_id, required: false
end
