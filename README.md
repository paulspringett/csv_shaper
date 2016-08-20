# CSV Shaper

Beautiful DSL for creating CSV output in Ruby & Rails.

Creating CSV files in Ruby is painful! CSV Shaper makes life easier! It's ideal for converting database backed models with attributes into CSV output. It can be used without Rails, but works great with ActiveRecord models and even comes with support for its own template handling.

[![Build Status](https://secure.travis-ci.org/paulspringett/csv_shaper.png?branch=master)](http://travis-ci.org/paulspringett/csv_shaper)
[![Code Climate](https://codeclimate.com/github/paulspringett/csv_shaper.png)](https://codeclimate.com/github/paulspringett/csv_shaper)

Annotated source: http://paulspringett.github.com/csv_shaper/

### Example Usage

```ruby
csv_string = CsvShaper.encode do |csv|
  csv.headers :name, :age, :gender, :pet_names

  csv.rows @users do |csv, user|
    csv.cells :name, :age, :gender

    if user.pets.any?
      csv.cell :pet_names
    end
  end
end
```

### Install

**Requires Ruby 2.0+**

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

When using it in Rails your view template is rendered inside the `encode` block so you can just call the `csv` object directly.

In Rails the example at the top of the README would simply be:

```ruby
csv.headers :name, :age, :gender, :pet_names

csv.rows @users do |csv, user|
  csv.cells :name, :age, :gender

  if user.pets.any?
    csv.cell :pet_names
  end
end
```

Create a Rails view, set the content-type to `csv` and the handler to `shaper`. For the view of the `index` action the filename would be:

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

The mappings are useful for pretty-ing up the names when creating the CSV. When creating cells below you should still use the column names, not the mapping names. eg. `:name` not `'Full name'`

#### Specify the header inflector method

Sometimes you may wish to control how headers are transformed from the symbol form.  The default `inflector` is set to `:humanize`.

```ruby
csv.headers do |csv|
  csv.columns :full_name, :age, :full_address
  csv.inflector :titleize
end
```

This would create headers like so:

```csv
Full Name,Age,Full Address
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

This will call the column names (name, age...) on `@user` and assign them to the correct cells. The output from the above Ruby might look like:

```
Paul,27,United Kingdom
```

#### Passing a model to a block

```ruby
csv.row @user do |csv, user|
  csv.cells :name, :age
  if user.show_gender?
    csv.cell :gender
  end

  csv.cell :exported_at, Date.today.to_formatted_s(:db)
end
```

Any calls here to `cell` without a second argument are called on the model (`user`), otherwise the second parameter is used as a static value.

The `cells` method only takes a list of Symbols that are called as methods on the model (`user`).

The output from the above Ruby might look like:

```
Paul,27,Male,2012-07-25
```

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

### CSV configuration

To configure how the CSV output is formatted you can define a configure block, like so:

```ruby
CsvShaper.configure do |config|
  config.col_sep = "\t"
  config.write_headers = false
end
```

Inside the block you can pass any of the standard library [CSV DEFAULT_OPTIONS](http://ruby-doc.org/stdlib-1.9.2/libdoc/csv/rdoc/CSV.html#DEFAULT_OPTIONS), as well as a `write_headers` option (default: `true`).
Setting this to `false` will exclude the headers from the final CSV output.

If you're using Rails you can put this in an initializer.

To configure CSV output locally to change global behavior you can define a configure hash, like so:

```ruby
CsvShaper.encode(col_sep: "\t") do |csv|
  ...
end
```

To configure Rails template-specific CSV output, use the `config` method on the `csv` object:

```ruby
csv.config.col_sep = "\t"
```

### Contributing

1. Fork it
2. Create a semantically named feature branch
3. Write your feature
4. Add some tests for it
5. Commit your changes & push to GitHub (do not change the gem's version number)
6. Submit a pull request with relevant details

##### Hat tips

* [Jbuilder](https://github.com/rails/jbuilder/) for inspiration for the DSL
* [CSV Builder](https://github.com/econsultancy/csv_builder) for headers and custom filenames

Copyright (c) Paul Springett 2012
