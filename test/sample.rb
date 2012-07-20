require './lib/csv_shaper'
require './test/models/user'

user = User.new
user.name = "Paul"
user.age = 26
user.gender = "Male"

users = [user]

shaper = CsvShaper::Shaper.encode do |csv|

  csv.headers do |csv|
    csv.columns :name, :gender, :age, :foo, :bar
    csv.mappings name: "Full name", gender: "Sex"
  end
  
  csv.rows users do |csv, user|
    csv.cells :name, :age
    csv.cell :gender
    # csv.cells :foo, :bar
  end

end

puts shaper.inspect