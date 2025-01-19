FactoryBot.define do
  factory :recipe_category do
    sequence(:name) do |n|
      "Recipe category: %d" % n
    end
  end
end
