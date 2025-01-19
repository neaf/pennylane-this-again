module Recipes
  class SearchesController < ApplicationController
    def create
      searcher = Recipes::Searcher.new(
        ingredients: search_params[:ingredients]
      )

      @recipes = searcher.recipes

      render "recipes/searches/create"
    end

    def search_params
      params.permit(:ingredients)
    end
  end
end
