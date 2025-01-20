require "rails_helper"

RSpec.describe Recipes::SearchesController, type: :controller do
  describe "#new" do
    it "renders new template" do
      get :new

      expect(response).to render_template("recipes/searches/new")
    end
  end

  describe "#results" do
    context "with valid params" do
      let(:params) do
        {
          ingredients: ingredients,
        }
      end

      let(:ingredients) do
        <<~TEXT
        milk, butter,   frozen blueberries

           strawberries
        TEXT
      end

      let(:ingredients_list) do
        [
          "milk",
          "butter",
          "frozen blueberries",
          "strawberries"
        ]
      end

      let(:found_recipes) do
        [
          create(:recipe),
          create(:recipe),
        ]
      end

      it "responds with recipes found using Recipes::Searcher" do
        expect_method_object_call(
          object: Recipes::Searcher,
          init_arguments: {
            ingredients: ingredients_list,
          },
          method: :recipes,
          return_value: found_recipes,
        )

        get :results, params: params

        expect(assigns(:recipes)).to eq(found_recipes)
        expect(response).to render_template("recipes/searches/results")
      end
    end
  end
end
