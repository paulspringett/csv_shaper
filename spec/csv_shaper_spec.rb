require 'spec_helper'

describe CsvShaper::Shaper do
  it "should return a version" do
    expect(CsvShaper::VERSION).to be_kind_of(String)
  end

  it "should raise an exception when passing a non-enumarble to rows" do
    csv = CsvShaper::Shaper.new
    expect {
      csv.rows :name
    }.to raise_exception(ArgumentError, 'csv.rows only accepts Enumerable object (that respond to #each). Use csv.row for a single object.')
  end

  it "should respond to to_csv" do
    csv = CsvShaper::Shaper.new
    expect(csv).to respond_to(:to_csv)
  end

  it "should provide a shortcut to the encode method" do
    expect(CsvShaper).to respond_to(:encode)

    CsvShaper.encode do |csv|
      csv.headers :foo
      expect(csv).to be_instance_of(CsvShaper::Shaper)
    end
  end
end
