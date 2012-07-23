# CSV Shaper

Beautiful DSL for creating CSV output in Ruby & Rails.

Creating CSV files in Ruby is painful! CSV Shaper makes life easier! It's ideal for converting database backed models with attrbiutes into CSV output. It can be used without Rails, but works great with ActiveRecord models and even comes with support for it's own template handling.

[![Build Status](https://secure.travis-ci.org/paulspringett/csv_shaper.png?branch=master)](http://travis-ci.org/paulspringett/csv_shaper)

### Example Usage

```ruby
csv_string = CsvShaper::Shaper.encode do |csv|
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

```bash
$ gem install csv_shaper
```

Or if you want to use it in your Rails app, add the following line to your Gemfile

```ruby
gem 'csv_shaper'
```

and then run

```bash
$ bundle install
```

### Usage

Everything goes inside the `encode` block, like so

```ruby
csv_string = CsvShaper::Shaper.encode do |csv|
  ...
end
```

### Usage in Rails 3.0+

If you're using it in Rails 3.0+ you are already inside the `encode` block so you can just call the `csv` object directly.

Create a Rails view, set the content-type to `csv` and the handler to `shaper`, like so

    index.csv.shaper
    
then just start defining your headers and rows as per the examples.

### Headers

You must define the headers for your CSV output. This can be done in one of 3 ways.

#### Standard attribute list

```ruby
csv.headers :name, :age, :location
```

This would create headers like so:

```csv
Name,Age,Location
```

#### Using the attribute names of a Class

Say you have a User ActiveRecord class with attributes of `:name, :age, :location`. Simply pass the class to the headers method

```ruby
csv.headers User
```

#### Using a block to define headers and custom mappings

```ruby
csv.headers do |csv|
  csv.columns :name, :age, :location
  csv.mappings name: 'Full name', location: 'Region'
end
```

This would create headers like so:

```csv
Full name,Age,Region
```

### Rows & Cells

CSV Shaper allows you to define rows and cells in a variety of ways.

#### Basic row without a model

```ruby
csv.row do |csv|
  csv.cell :name, "Joe"
  csv.cell :age, 24
end
```

#### Passing a model and attributes

```ruby
csv.row @user, :name, :age, :location
```

This will call the column names (name, age...) on @user and assign them to the correct cells.

#### Passing a model to a block

```ruby
csv.row @user, do |csv, user|
  csv.cells :name, :age
  if user.show_gender?
    csv.cell :gender
  end

  csv.cell :exported_at, Time.now
end
```

Any calls here to `cell` or `cells` without a value are called on the model (`user`), otherwise the second parameter is assigned.

### Multiple Rows

You can pass an Enumerable and a block to `csv.rows` like so

```ruby
csv.rows @users do |csv, user|
  csv.cells :name, :age, :location, :gender
  csv.cell :exported_at, Time.now
end
```

### Don't worry about missing cells

There's no need to pad missing cells with `nil`

This Ruby code will produce the CSV output below

```ruby
csv.headers :name, :age, :gender

csv.row do |csv|
  csv.cell :name, 'Paul'
  # no age cell
  csv.cell :gender, 'M'
end

csv.row do |csv|
  csv.cell :name 'Joe'
  csv.cell :age, 34
  # no gender cell
end
```

```
Name,Age,Gender
Paul,,M
Joe,34,
```

### Further Rails integration

Customise the filename of the CSV download by defining a `@filename` instance variable in your controller action.

```ruby
respond_to :html, :csv

def index
  @users = User.all
  @filename = "All users - #{Date.today.to_formatted_s(:db)}.csv"
end
```

##### Hat tips

* [Jbuilder](https://github.com/rails/jbuilder/) for inspiration for the DSL
* [CSV Builder](https://github.com/econsultancy/csv_builder) for headers and custom filenames

Copyright (c) Paul Springett 2012