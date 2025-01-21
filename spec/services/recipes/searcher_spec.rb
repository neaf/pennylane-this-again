require "rails_helper"

RSpec.describe Recipes::Searcher do
  subject(:searcher) do
    described_class.new(
      ingredients: search_ingredients,
      use_ratio: use_ratio,
    )
  end

  let(:use_ratio) do
    false
  end

  let!(:recipes) do
    [
      create(:recipe, ingredients: [
        "2 cups uncooked glutinous white rice",
        "4 cups water",
        "6 eggs, beaten",
        "6 sheets nori (dry seaweed)",
        "¼ cup basil pesto",
        "salt and pepper to taste",
      ]),
      create(:recipe, ingredients: [
        "1 pound skinless, boneless chicken breasts",
        "½ cup Italian-style salad dressing, or to taste",
        "3 ounces Brie cheese, sliced",
        "1 tablespoon olive oil, divided",
        "2 cups cherry tomatoes, halved",
        "¼ teaspoon kosher salt, divided",
        "3 tablespoons balsamic vinegar, divided",
        "1 tablespoon chopped fresh basil",
        "2 cups fresh spinach leaves",
        "¼ cup mayonnaise",
        "1 tablespoon Dijon mustard",
        "2 cloves garlic, minced",
        "⅛ teaspoon ground black pepper",
        "1 loaf French bread, halved lengthwise",
      ]),
      create(:recipe, ingredients: [
        "1 cup tightly packed chopped parsley leaves",
        "1 cup tightly packed chopped cilantro leaves",
        "¼ cup red wine vinegar",
        "½ onion, coarsely chopped",
        "5 cloves garlic",
        "1 teaspoon coarse salt",
        "1 teaspoon dried oregano",
        "1 cup of crunched oregano",
        "1 bunch of fresh oregano",
        "3 oregano leaves",
        "1 teaspoon hot pepper flakes",
        "1 teaspoon freshly ground black pepper",
        "½ cup extra-virgin olive oil",
      ]),
      create(:recipe, ingredients: [
        "1 ⅓ cups brown sugar",
        "2 tablespoons ground cinnamon",
        "1 tablespoon butter",
        "2 teaspoons honey",
        "8 small Golden Delicious apples, peeled and cut into small pieces",
        "1 refrigerated pie crust",
      ]),
      create(:recipe, ingredients: [
        "1 (15 ounce) package beef roast in au jus",
        "1 (8.5 ounce) package UNCLE BEN'S® Jasmine READY RICE®",
        "1 tablespoon vegetable oil, divided",
        "1 (8 ounce) package button mushrooms, quartered",
        "1 teaspoon Korean barbecue sauce",
        "4 cups baby spinach",
        "1 clove garlic, finely chopped",
        "2 cups shredded carrots",
        "1 teaspoon chopped fresh ginger root",
        "2 tablespoons Korean barbecue sauce, or to taste",
      ]),
    ]
  end

  describe "#recipes" do
    describe "empty search ingredients behaviour" do
      let(:search_ingredients) do
        []
      end

      it "returns no recipes" do
        expect(searcher.recipes).to eq([])
      end
    end

    describe "rejecting recipes without matching ingredients" do
      let(:search_ingredients) do
        [
          "vinegar",
          "garlic",
          "spinach"
        ]
      end

      it "returns only matching recipes" do
        expect(searcher.recipes).to match_array(recipes.values_at(
          1, 2, 4
        ))
      end
    end

    describe "promoting recipes with most matching ingredients" do
      let(:search_ingredients) do
        [
          "vinegar",
          "garlic",
          "spinach",
          "onions",
          "oregano",
          "beef",
          "carrots",
        ]
      end

      it "orders by amount of matching ingredients" do
        expect(searcher.recipes).to eq(recipes.values_at(
          2, 4, 1
        ))
      end
    end

    describe "demoting recipes with most non-matching ingredients" do
      let(:search_ingredients) do
        [
          "spinach",
          "garlic",
        ]
      end

      it "orders descendingly by amount of matching ingredients" do
        expect(searcher.recipes).to eq(recipes.values_at(
          4, 1, 2
        ))
      end
    end

    describe "prevents promoting repeated matches" do
      let(:search_ingredients) do
        [
          "oregano",
          "mayonnaise",
          "mustard",
        ]
      end

      it "does not put recipes with repeated matches above others" do
        expect(searcher.recipes).to eq(recipes.values_at(
          1, 2
        ))
      end
    end

    describe "fuzzy matching ingredients" do
      let(:search_ingredients) do
        [
          "mayonnase",
        ]
      end

      it "returns recipes with mistyped search ingredients" do
        expect(searcher.recipes).to match_array(recipes.values_at(
          1
        ))
      end
    end

    describe "ratio based ordering" do
      let(:use_ratio) do
        true
      end

      let(:search_ingredients) do
        [
          "sugar",
          "cinnamon",
          "butter",
          "honey",
          "chicken",
          "cheese",
          "olive oil",
          "tomatoes",
          "vinegar",
        ]
      end

      it "promotes recipes with best matching ration over most matching ingredients" do
        expect(searcher.recipes).to eq(recipes.values_at(
          3, 1, 2
        ))
      end
    end

    describe "case insensitivity" do
      let(:search_ingredients) do
        [
          "OLIVE OIL",
        ]
      end

      it "returns recipes with mistyped search ingredients" do
        expect(searcher.recipes).to match_array(recipes.values_at(
          1, 2
        ))
      end
    end
  end
end
