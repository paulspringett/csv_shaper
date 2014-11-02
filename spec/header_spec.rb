require 'spec_helper'
require 'fixtures/user'

describe CsvShaper::Header do

  before(:each) do
    config = double(:config, options: { header_inflector: :humanize })
    allow(CsvShaper::Shaper).to receive(:config) { config }
  end

  it "should accept and store a list of symbols" do
    header = CsvShaper::Header.new(:name, :age, :location)

    expect(header.columns).to eq [:name, :age, :location]
  end

  it "should accept a Model and store it's attributes" do
    header = CsvShaper::Header.new(User)

    expect(header.columns).to eq [:name, :age, :gender]
  end

  it "should accept a block with columns and mappings" do
    header = CsvShaper::Header.new do |csv|
      csv.columns :name, :age, :foo
      csv.mappings name: 'User name'
    end

    expect(header.columns).to eq [:name, :age, :foo]
    expect(header.mapped_columns).to eq ['User name', 'Age', 'Foo']
  end

  it "should titleize column names according to the chosen inflector" do
    header = CsvShaper::Header.new do |csv|
      csv.columns :first_name, :full_age
      csv.inflector :titleize
    end

    expect(header.columns).to eq [:first_name, :full_age]
    expect(header.mapped_columns).to eq ['First Name', 'Full Age']
  end

  it "should merge columns with a union join" do
    header = CsvShaper::Header.new(:name, :age, :location)
    header.columns :age, :gender

    expect(header.columns).to eq [:name, :age, :location, :gender]
  end

  it "should merge mappings" do
    header = CsvShaper::Header.new do |csv|
      csv.columns :name, :age, :foo
      csv.mappings name: 'User name'
      csv.mappings foo: 'Bar'
    end

    expect(header.mapped_columns).to eq ['User name', 'Age', 'Bar']
  end
end
