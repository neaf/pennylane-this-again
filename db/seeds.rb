recipes_file_path = Rails.root.join("db", "seeds", "recipes-en.json")

recipes = JSON.parse(File.read(recipes_file_path))

recipes.each.with_index do |recipe, index|
  category = RecipeCategory.find_or_create_by!(name: recipe["category"])

  print "\rImporting recipes: #{index + 1}/#{recipes.count}"

  Recipe.create!(
    title: recipe["title"],
    cook_time_minutes: recipe["cook_time"],
    prep_time_minutes: recipe["prep_time"],
    rating: recipe["rating"],
    author_name: recipe["author"],
    image_url: recipe["image"],
    category: category,
  ).tap do |r|
    recipe["ingredients"].each do |ingredient|
      r.ingredients.create!(
        ingredient: ingredient,
      )
    end
  end
end
