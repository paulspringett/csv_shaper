# CSV Shaper

Beautiful DSL for creating CSV output in Ruby.

### Example Usage

```ruby
CsvShaper::Shaper.encode do |csv|
  
  csv.header :name, :age, :gender, :pet_names
  
  csv.rows @users do |csv, user|
    csv.cells :name, :age, :gender
    
    if user.pets.any?
      csv.cell :pet_names
    end
  end
end
```

### Install

Install using Rubygems

    $ gem install csv-shaper

Or if you want to use it in your Rails app, add the following line to your Gemfile

    gem 'csv-shaper'

Copyright (c) Paul Springett 2012






TODO:

* Rails integration testing
* Publish to RubyGems.org
* Travis CI setup
* Full README with examples
* Peer-review?











