class CreateRecipeIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :recipe_ingredients do |t|
      t.belongs_to :recipe, null: false, foreign_key: true
      t.string :ingredient, null: false

      t.timestamps
    end

    add_index :recipe_ingredients, :ingredient, using: :gist, opclass: :gist_trgm_ops
  end
end
