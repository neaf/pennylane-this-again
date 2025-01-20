class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string :title, null: false
      t.integer :cook_time_minutes
      t.integer :prep_time_minutes
      t.decimal :rating
      t.string :author_name
      t.references :recipe_category, null: true, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
