require './lib/csv_shaper'
require './test/models/user'

shaper = CsvShaper::Shaper.encode do |csv|
  
  csv.header User do |header|
    header.columns :name, :gender
    header.mappings :name => "Username", :gender => "Sex"
  end
  
end

puts shaper.inspect