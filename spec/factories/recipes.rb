FactoryBot.define do
  factory :recipe do
    title do
      Faker::Food.dish
    end

    ingredients do
      rand(0...10).times.map do
        [
          Faker::Food.measurement,
          Faker::Food.ingredient,
        ].join(" ")
      end
    end

    prep_time_minutes do
      rand(5...60)
    end

    cook_time_minutes do
      rand(5...60)
    end

    rating do
      rand(1.0...5.0).round(1)
    end

    author_name do
      Faker::Name.name
    end

    image_url do
      Faker::Internet.url(host: "example.com", path: "/image.jpg")
    end

    association(:category, factory: :recipe_category)
  end
end
