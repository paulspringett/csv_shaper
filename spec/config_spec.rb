require 'spec_helper'

describe CsvShaper::Config do
  it "should assign options to config" do
    config = CsvShaper::Config.new do |c|
      c.write_headers = false
      c.col_sep = '\t'
    end
    config.options.should eq({ write_headers: false, col_sep: '\t' })
  end  
end
