# README

Hello Pennylane people!

My first thought after reading the task description was the following:

The tool is so not critical that no one is going to endure any amount of friction. People want to sloppily type or dictate stuff and expect us to make it work. Hence I, opted for super simple input interface, even if that means sacrificing results "accuracy".

Using trigram similarity might match "olives" with "olive oil" or miss "rice" in "1 (8.5 ounce) package UNCLE BEN'S® Jasmine READY RICE®". However, assuming no recipe is going to exactly match the user's stock and people will mostly use the app for inspiration, I tried to select a treshold that strucks the right balance between input forgiveness and correctness of results.

It was a fun little challenge, even more so because I received it right after I promised my girlfriend to prepare a weekly meal plan, so we can avoid decision fatigue every other day. :)

I hope you enjoy playing with the solution.

# Functionality

The app accepts a list of grocery ingredients and searches for recipes that best utilizes those.

By default, it'll provide recipes that use the most ingredients present in user's stock. This is useful in case avoiding things to expire is a decision factor. It also promotes more complex recipes, which hopefully translates to bigger meal enjoyment.

By selecting "That's all I have", the user is presented with recipes that more closely match their stock. The recipes tend to be simpler but should require fewer ingredient substitutions or new purchases.

# Running

Deployed instance can be found here:

[https://this-again.fly.dev/](https://this-again.fly.dev/)

However, only after deploying I had a chance to discover the small DB intsance on fly.io is not to be fully trusted with such query.

For most enjoyable experience let's setup it locally:

``` sh
$ git clone git@github.com:neaf/pennylane-this-again.git
$ cd pennylane-this-again

$ cp config/database.yml.example config/database.yml
$ vim config/database.yml

$ bundle install

$ rake db:create db:migrate db:seed

$ bundle exec rspec

$ rails s
$ open "http://localhost:8080"
```

# Comments

1. Normally I avoid such database query complexity. It can be almost impossible to understand without one-to-one explanation, hard to modify and couple the app to specific database engine. However, as long as it doesn't produce side effects (like creating normalized views or triggers) and is localized to one spot, I think it's worth doing that over complicating the stack with additional technologies.

2. Regardless of how the database is run, it is a limiting factor for number of search ingredients or query comlexity when working with raw data. It works well enough for a proof of concept, however I'd explore using elasticsearch with similar logic in a next iteration.
