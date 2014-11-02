require 'spec_helper'
require 'fixtures/user'

describe CsvShaper::Row do
  let(:user) { User.new(name: 'Paul', age: 27, gender: 'Male') }

  it "should assign a model" do
    row = CsvShaper::Row.new user do |csv, user|
      # ...
    end

    expect(row.model).to eq user
  end

  it "should assign a model's attributes" do
    row = CsvShaper::Row.new(user, :name, :age)
    expect(row.cells).to eq({ name: 'Paul', age: 27 })
  end

  it "should yield to a block" do
    CsvShaper::Row.new { |csv|
      expect(csv).to be_kind_of(CsvShaper::Row)
    }
  end

  describe "cells" do
    it "should send parse an attribute of the model" do
      row = CsvShaper::Row.new(user, :gender)
      row.cell :name
      expect(row.cells).to eq({ name: 'Paul', gender: 'Male' })
    end

    it "should send assign an unrelated value" do
      row = CsvShaper::Row.new(user, :gender)
      row.cell :foo, 'bar'
      expect(row.cells).to eq({ foo: 'bar', gender: 'Male' })
    end

    it "ignore nil values passed" do
      row = CsvShaper::Row.new(user, :gender)
      row.cell :foo, nil
      expect(row.cells).to eq({ foo: nil, gender: 'Male' })
    end

    it "should not send column to model if two args are passed" do
      row = CsvShaper::Row.new(user, :gender)
      row.cell :name, 'Another name'
      expect(row.cells).to eq({ name: 'Another name', gender: 'Male' })
    end

    it "should raise an exception if the model does not respond to column, and no value is passed" do
      row = CsvShaper::Row.new(user, :gender)
      expect {
        row.cell :foo
      }.to raise_error(ArgumentError)
    end
  end
end
