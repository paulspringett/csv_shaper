require 'spec_helper'
require 'fixtures/user'

describe CsvShaper::Row do
  let(:user) { User.new(name: 'Paul', age: 27, gender: 'Male') }
  
  it "should assign a model" do
    row = CsvShaper::Row.new user do |csv, user|
      # ...
    end

    row.model.should eq user
  end
  
  it "should assign a model's attributes" do
    row = CsvShaper::Row.new(user, :name, :age)
    row.cells.should eq({ name: 'Paul', age: 27 })
  end
  
  it "should yield to a block" do
    CsvShaper::Row.new { |csv|
      csv.should be_kind_of(CsvShaper::Row)
    }
  end
end
