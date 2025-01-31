# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_01_20_162318) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "recipe_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_ingredients", force: :cascade do |t|
    t.bigint "recipe_id", null: false
    t.string "ingredient", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient"], name: "index_recipe_ingredients_on_ingredient", opclass: :gist_trgm_ops, using: :gist
    t.index ["recipe_id"], name: "index_recipe_ingredients_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.string "title", null: false
    t.string "ingredients", default: [], null: false, array: true
    t.integer "cook_time_minutes"
    t.integer "prep_time_minutes"
    t.decimal "rating"
    t.string "author_name"
    t.bigint "recipe_category_id"
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredients"], name: "index_recipes_on_ingredients", using: :gin
    t.index ["recipe_category_id"], name: "index_recipes_on_recipe_category_id"
  end

  add_foreign_key "recipe_ingredients", "recipes"
  add_foreign_key "recipes", "recipe_categories"
end
