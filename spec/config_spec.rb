require 'spec_helper'

describe CsvShaper::Config do
  let(:config) {
    CsvShaper::Config.new do |c|
      c.write_headers = false
      c.col_sep = "\t"
    end
  }
  
  it "should assign options to config" do
    config.options.should eq({ :write_headers => false, :col_sep => "\t" })
  end
  
  it "should exclude the headers if specified" do
    CsvShaper::Shaper.config = config
    
    shaper = CsvShaper::Shaper.new do |csv|
      csv.headers :name, :age, :gender
      
      csv.row do |csv|
        csv.cell :name, 'Paul'
        csv.cell :age, '27'
        csv.cell :gender, 'Male'
      end
    end
    
    shaper.to_csv.should eq "Paul\t27\tMale\n"
  end
end
