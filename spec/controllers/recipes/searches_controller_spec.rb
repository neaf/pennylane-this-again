require "rails_helper"

RSpec.describe Recipes::SearchesController, type: :controller do
  describe "#create" do
    let(:params) do
      {
        ingredients: ingredients,
      }
    end

    let(:ingredients) do
      "milk, butter, frozen blueberries, strawberries"
    end

    let(:found_recipes) do
      [
        create(:recipe),
        create(:recipe),
      ]
    end

    it "responds with recipes found with Recipes::Searcher" do
      expect_method_object_call(
        object: Recipes::Searcher,
        init_arguments: {
          ingredients: ingredients,
        },
        method: :recipes,
        return_value: found_recipes,
      )

      post :create, params: params

      expect(assigns(:recipes)).to eq(found_recipes)
      expect(response).to render_template("recipes/searches/create")
    end
  end
end
