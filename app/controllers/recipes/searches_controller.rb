module Recipes
  class SearchesController < ApplicationController
    def new
      render "recipes/searches/new"
    end

    def results
      @search_sanitizer = SearchSanitizer.new(
        ingredients: search_params[:ingredients],
      )

      searcher = Recipes::Searcher.new(
        ingredients: @search_sanitizer.ingredients_list,
      )

      @recipes = searcher.recipes

      render "recipes/searches/results"
    end

    def search_params
      params.permit(:ingredients)
    end

    class SearchSanitizer
      attr_reader :ingredients

      def initialize(ingredients: nil)
        @ingredients = ingredients
      end

      def ingredients_list
        if ingredients.blank?
          return []
        end

        ingredients.split(/[\n,]/).map(&:strip)
      end
    end
  end
end
