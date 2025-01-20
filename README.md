# README

Hello Pennylane people!

My first thought after reading the task description was the following:

The tool is so not critical that no one is going to endure any amount of friction. People want to sloppily type or dictate stuff and expect us to make it work. Hence I, opted for super simple input interface, even if that means sacrificing results "accuracy".

Using trigram similarity might match "olives" with "olive oil" or miss "rice" in "1 (8.5 ounce) package UNCLE BEN'S® Jasmine READY RICE®". However, assuming no recipe is going to exactly match the user's stock and people will mostly use the app for inspiration, I tried to select a treshold that strucks the right balance between input forgiveness and correctness of results.

It was a fun little challenge, even more so because I received it right after I promised my girlfriend to prepare a weekly meal plan, so we can avoid decision fatigue every other day. :)

I hope you enjoying playing with the solution.

# Running

Deploy version can be found here:

[https://this-again.fly.dev/](https://this-again.fly.dev/)

However, only after deploying I had a chance to conclude the performance on fly.io is not great. The DB takes long time to respond despite it's CPU and memory being utilized only up to 20%.

On development machine it takes around 500-600ms for ten search ingredients. Not ideal, but snappy enough.

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

# Comment

Regardless of how the database is run, the performance issue is unfortunate but discovered too late to react within the scope of the recruitment task. It works great as a proof of concept and the app is fun enough to deserve a second iteration. I'd explore using elasticsearch with similar logic as it would probably handle the search ingredients array better.
