module Recipes
  class Searcher
    attr_reader :ingredients

    def initialize(ingredients:)
      @ingredients = ingredients
    end

    def recipes
      @recipes ||= begin
        if ingredients.empty?
          return Recipe.none
        end

        search_ingredients = ActiveRecord::Base.send(:sanitize_sql_array, ["ARRAY[?]::text[]", ingredients])

        Recipe
          .joins(
            "JOIN LATERAL unnest(recipes.ingredients::text[]) AS db_ingredients(ingredient) ON true"
          ) # multiply records by recipe ingredients
          .joins(
            "JOIN LATERAL unnest(%s) AS search(ingredient) ON true" % search_ingredients
          ) # multiply records by search ingredients
          .select("recipes.*")
          .select(
            "COUNT(DISTINCT search.ingredient) FILTER (WHERE similarity(db_ingredients.ingredient, search.ingredient) > 0.2) AS matching_ingredients_count"
          ) # count matching ingredients to promote utilizing most of the stock, DISTINCT prevents promoting repeated ingredients
          .select(
            "COUNT(DISTINCT db_ingredients.ingredient) - COUNT(DISTINCT search.ingredient) FILTER (WHERE similarity(db_ingredients.ingredient, search.ingredient) > 0.2) AS non_matching_ingredients_count"
          ) # count non-matching ingredients to demote recipes requiring things missing from the stock
          .select(
            "ARRAY_AGG(DISTINCT db_ingredients.ingredient) FILTER (WHERE similarity(db_ingredients.ingredient, search.ingredient) > 0.2) AS matching_ingredients"
          ) # gather matching ingredients from records grouped by recipe, used for highlighting in UI
          .group("recipes.id") # collapse multipied records
          .having(
            "COUNT(DISTINCT search.ingredient) FILTER (WHERE similarity(db_ingredients.ingredient, search.ingredient) > 0.2) > 0"
          ) # select recipes with at least one matching ingredient
          .order(
            "matching_ingredients_count DESC, non_matching_ingredients_count ASC, recipes.id"
          )
          .limit(10)
      end
    end
  end
end
