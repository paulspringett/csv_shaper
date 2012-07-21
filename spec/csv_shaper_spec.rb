require 'spec_helper'

describe CsvShaper::Shaper do
  it "should return a version" do
    CsvShaper::VERSION.should be_kind_of(String)
  end
  
  it "should raise an exception when passing a non-enumarble to rows" do
    csv = CsvShaper::Shaper.new
    expect {
      csv.rows :name
    }.to raise_exception(ArgumentError, 'csv.rows only accepts Enumerable object (that respond to #each). Use csv.row for a single object.')
  end
  
  it "should respond to to_csv" do
    csv = CsvShaper::Shaper.new
    csv.should respond_to(:to_csv)
  end
end
