module Recipes
  class Searcher
    attr_reader :ingredients

    def initialize(ingredients:)
      @ingredients = ingredients
    end

    def recipes
      if ingredients.empty?
       return Recipe.none
      end

      search_ingredients = ActiveRecord::Base.send(:sanitize_sql_array, ["ARRAY[?]::text[]", ingredients])

      Recipe
        .select("recipes.*")
        .select("ARRAY_AGG(DISTINCT db_ingredients.ingredient) FILTER (WHERE similarity(db_ingredients.ingredient, search.ingredient) > 0.2) AS matching_ingredients")
        .select("COUNT(DISTINCT search.ingredient) FILTER (WHERE similarity(db_ingredients.ingredient, search.ingredient) > 0.2) AS matching_ingredients_count")
        .select("COUNT(db_ingredients.ingredient) - COUNT(DISTINCT search.ingredient) FILTER (WHERE similarity(db_ingredients.ingredient, search.ingredient) > 0.2) AS non_matching_ingredients_count")
        .joins("JOIN LATERAL unnest(recipes.ingredients::text[]) AS db_ingredients(ingredient) ON true")
        .joins("JOIN LATERAL unnest(%s) AS search(ingredient) ON true" % search_ingredients)
        .group("recipes.id")
        .order("matching_ingredients_count DESC, non_matching_ingredients_count ASC, recipes.id")
        .limit(10)
    end
  end
end
