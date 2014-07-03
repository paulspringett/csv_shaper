require 'spec_helper'

describe CsvShaper::Config do
  let(:config) {
    CsvShaper::Config.new do |c|
      c.write_headers = false
      c.col_sep = "\t"
      c.header_inflector = :titleize
    end
  }

  it "should assign options to config" do
    config.options.should eq({ write_headers: false, col_sep: "\t", header_inflector: :titleize })
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

  it "should allow change configuration locally" do
    CsvShaper::Shaper.config = config

    shaper = CsvShaper::Shaper.new(col_sep: ",") do |csv|
      csv.headers :name, :age, :gender

      csv.row do |csv|
        csv.cell :name, 'Paul'
        csv.cell :age, '27'
        csv.cell :gender, 'Male'
      end
    end

    shaper.to_csv.should eq "Paul,27,Male\n"
  end

  it "should allow change inflector locally" do
    CsvShaper::Shaper.config = config

    shaper = CsvShaper::Shaper.new(col_sep: ",", write_headers: true, header_inflector: :titleize) do |csv|
      csv.headers :full_name, :age, :gender

      csv.row do |csv|
        csv.cell :full_name, 'Paul'
        csv.cell :age, '27'
        csv.cell :gender, 'Male'
      end
    end

    shaper.to_csv.should eq "Full Name,Age,Gender\nPaul,27,Male\n"
  end
end
