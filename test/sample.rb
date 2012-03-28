require './lib/csv_shaper'
require './test/models/user'

user = User.new
user.name = "Paul"
user.age = 26
user.gender = "Male"

users = [user]

shaper = CsvShaper::Shaper.encode do |csv|

  csv.header User do |header|
    header.columns :name, :gender, :age, :foo, :bar
    header.mappings name: "Full name", gender: "Sex"
  end

  csv.row users do |csv, user|
    csv.cells :name, :age
    csv.cell :gender if user.human?
    csv.cells :foo, :bar
  end

end

puts shaper.inspect