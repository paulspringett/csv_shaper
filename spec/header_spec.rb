require 'spec_helper'
require 'fixtures/user'

describe CsvShaper::Header do

  before(:each) do
    CsvShaper::Shaper.stub_chain(:config, :options).and_return({ header_inflector: :humanize})
  end

  it "should accept and store a list of symbols" do
    header = CsvShaper::Header.new(:name, :age, :location)

    header.columns.should eq [:name, :age, :location]
  end

  it "should accept a Model and store it's attributes" do
    header = CsvShaper::Header.new(User)

    header.columns.should eq [:name, :age, :gender]
  end

  it "should accept a block with columns and mappings" do
    header = CsvShaper::Header.new do |csv|
      csv.columns :name, :age, :foo
      csv.mappings name: 'User name'
    end

    header.columns.should eq [:name, :age, :foo]
    header.mapped_columns.should eq ['User name', 'Age', 'Foo']
  end

  it "should titleize column names according to the chosen inflector" do
    header = CsvShaper::Header.new do |csv|
      csv.columns :first_name, :full_age
      csv.inflector :titleize
    end

    header.columns.should eq [:first_name, :full_age]
    header.mapped_columns.should eq ['First Name', 'Full Age']
  end

  it "should merge columns with a union join" do
    header = CsvShaper::Header.new(:name, :age, :location)
    header.columns :age, :gender

    header.columns.should eq [:name, :age, :location, :gender]
  end

  it "should merge mappings" do
    header = CsvShaper::Header.new do |csv|
      csv.columns :name, :age, :foo
      csv.mappings name: 'User name'
      csv.mappings foo: 'Bar'
    end

    header.mapped_columns.should eq ['User name', 'Age', 'Bar']
  end
end
