require 'spec_helper'
require "csv_shaper_template"

describe CsvShaperTemplate do
  it "should allow configuration via #config method" do
    csv_string = CsvShaperTemplate.encode(double('context')) do |csv|
      csv.config.write_headers = false
      csv.config.col_sep = ';'

      csv.headers :name, :age, :gender

      csv.row do |csv|
        csv.cell :name, 'Paul'
        csv.cell :age, '27'
        csv.cell :gender, 'Male'
      end
    end

    expect(csv_string).to eq "Paul;27;Male\n"
  end

  it "should override global configuration with local configuration" do
    CsvShaper::Shaper.config = CsvShaper::Config.new do |c|
      c.write_headers = false
      c.col_sep = "\t"
    end

    csv_string = CsvShaperTemplate.encode(double('context')) do |csv|
      csv.config.col_sep = ','

      csv.headers :name, :age, :gender

      csv.row do |csv|
        csv.cell :name, 'Paul'
        csv.cell :age, '27'
        csv.cell :gender, 'Male'
      end
    end

    expect(csv_string).to eq "Paul,27,Male\n"
  end
end
