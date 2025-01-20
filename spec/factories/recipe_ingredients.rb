FactoryBot.define do
  factory :recipe_ingredient do
    ingredient do
      [
        Faker::Food.measurement,
        Faker::Food.ingredient,
      ].join(" ")
    end
  end
end
