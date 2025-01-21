module Recipes
  class Searcher
    INGREDIENT_COUNT_LIMIT = 15
    class TooManyIngredientsError < StandardError; end

    attr_reader :ingredients, :use_ratio

    def initialize(ingredients:, use_ratio:)
      @ingredients = ingredients
      @use_ratio = use_ratio
    end

    def recipes
      @recipes ||= begin
        validate_ingredient_count!

        if ingredients.empty?
          return Recipe.none
        end

        search_ingredients = ActiveRecord::Base.send(:sanitize_sql_array, ["ARRAY[?]::text[]", ingredients])
        ActiveRecord::Base.connection.execute("SET pg_trgm.similarity_threshold = 0.2")

        # Multiply recipes by their ingredents and search ingredients
        #
        matching_recipes = Recipe
          .joins(:ingredients)
          .joins(
            "JOIN LATERAL unnest(%s) AS search(ingredient) ON true" % search_ingredients
          )
          .select("recipes.*")
          .select("search.ingredient AS search_ingredient")
          .where("recipe_ingredients.ingredient % search.ingredient")
          .group("recipes.id", "search_ingredient")

        recipes_with_matching_ingredients = Recipe.from(matching_recipes, :recipes)
          .joins(:ingredients)
          .select("recipes.id, recipes.title")
          .select(
            "COUNT(DISTINCT search_ingredient) FILTER (WHERE recipe_ingredients.ingredient % search_ingredient) AS matching_ingredients_count"
          )
          .select(
            "ARRAY_AGG(DISTINCT recipe_ingredients.ingredient) FILTER (WHERE recipe_ingredients.ingredient % recipes.search_ingredient) AS matching_ingredients"
          )
          .group("recipes.id", "recipes.title")

        recipes_with_counts = Recipe.from(recipes_with_matching_ingredients, :recipes)
          .joins(:ingredients)
          .select("recipes.id, recipes.title, matching_ingredients_count, matching_ingredients")
          .select(
            "COUNT(DISTINCT recipe_ingredients.ingredient) FILTER (WHERE recipe_ingredients.ingredient NOT IN (SELECT unnest(matching_ingredients))) AS non_matching_ingredients_count"
          )
          .group("recipes.id", "recipes.title", "matching_ingredients_count", "matching_ingredients")

        Recipe.from(recipes_with_counts, :recipes)
          .includes(:ingredients)
          .select("recipes.id", "recipes.title")
          .select("matching_ingredients")
          .select("matching_ingredients_count")
          .select("non_matching_ingredients_count")
          .select(
            "CASE WHEN non_matching_ingredients_count = 0 THEN matching_ingredients_count ELSE matching_ingredients_count::float / (matching_ingredients_count + non_matching_ingredients_count) END AS matching_ratio"
          )
          .order(order_clause)
          .limit(10)
      end
    end

    def order_clause
      if use_ratio
        return "matching_ratio DESC"
      end

      "matching_ingredients_count DESC, non_matching_ingredients_count ASC"
    end

    private

    def validate_ingredient_count!
      if ingredients.count > INGREDIENT_COUNT_LIMIT
        raise TooManyIngredientsError
      end
    end
  end
end
