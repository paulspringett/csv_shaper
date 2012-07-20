require './lib/csv_shaper'
require './test/models/user'

user = User.new
user.name = "Paul"
user.age = 26
user.gender = "Male"

users = [user]

shaper = CsvShaper::Shaper.encode do |csv|

  csv.headers do |csv|
    csv.columns :name, :gender, :age
    csv.mappings name: "Full name", gender: "Sex"
  end
  
  # csv.headers User
  # csv.headers :name, :gender, :age

  csv.rows users do |csv, user|
    csv.cells :name, :age
    csv.cell :gender
  end

  csv.row do |csv|
  	csv.cell :age, 120 # total age
  end

end

puts shaper.inspect
puts shaper.header.inspect