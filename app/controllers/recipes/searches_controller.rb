module Recipes
  class SearchesController < ApplicationController
    def new
      render "recipes/searches/new"
    end

    def results
      @search_sanitizer = SearchSanitizer.new(
        params: search_params,
      )

      searcher = Recipes::Searcher.new(
        ingredients: @search_sanitizer.ingredients_list,
        use_ratio: @search_sanitizer.use_ratio?
      )

      @recipes = searcher.recipes

      render "recipes/searches/results"
    end

    def search_params
      params.permit(:ingredients, :use_ratio)
    end

    class SearchSanitizer
      attr_reader :params

      def initialize(params: nil)
        @params = params
      end

      def ingredients_list
        if params[:ingredients].blank?
          return []
        end

        params[:ingredients]
          .split(/[\n,]/)
          .map(&:strip)
          .reject(&:blank?)
      end

      def use_ratio?
        params[:use_ratio].present?
      end
    end
  end
end
