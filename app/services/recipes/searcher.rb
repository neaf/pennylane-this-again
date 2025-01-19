module Recipes
  class Searcher
    attr_reader :ingredients

    def initialize(ingredients:)
      @ingredients = ingredients
    end

    def recipes
      Recipe.all
    end
  end
end
