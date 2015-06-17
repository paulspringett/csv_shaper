require 'spec_helper'
require 'fixtures/user'

describe CsvShaper::Encoder do
  let(:user) { User.new(name: 'Paul', age: 27, gender: 'Male') }

  let(:config) {
    CsvShaper::Config.new do |c|
      c.write_headers = true
    end
  }

  it "should raise an exception if the headers are missing" do
    expect {
      CsvShaper::Encoder.new(nil)
    }.to raise_exception(CsvShaper::MissingHeadersError, 'you must define some headers using csv.headers ...')
  end

  let(:users) { [User.new(name: 'Paul', age: 27, gender: 'Male'), User.new(name: 'Bob', age: 31, gender: 'Male'), User.new(name: 'Jane', age: 23, gender: 'Female')] }
  let(:csv) {
    CsvShaper::Shaper.new do |csv|
      csv.headers do |csv|
        csv.columns :name, :gender, :age
        csv.mappings name: "Full name", gender: "Sex"
      end

      csv.rows users do |csv, user|
        csv.cells :name, :age
        csv.cell :gender
      end

      csv.row do |csv|
      	csv.cell :age, users.map(&:age).reduce(:+)
      end
    end
  }

  it "should encode a Shaper instance to a CSV string" do
    CsvShaper::Shaper.config = config
    encoder = CsvShaper::Encoder.new(csv.header, csv.rows)
    expect(encoder.to_csv).to eq("Full name,Sex,Age\nPaul,Male,27\nBob,Male,31\nJane,Female,23\n,,81\n")
  end

  it "should encode a Shaper instance with no rows to a CSV string" do
    CsvShaper::Shaper.config = config
    encoder = CsvShaper::Encoder.new(csv.header, [])
    expect(encoder.to_csv).to eq("Full name,Sex,Age\n")
  end
end
