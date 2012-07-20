require 'spec_helper'

describe CsvShaper do
  it "should return a version" do
    CsvShaper::VERSION.should be_kind_of(String)
  end
end
