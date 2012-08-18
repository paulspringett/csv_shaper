require 'csv'

module CsvShaper
  # Encoder
  # Takes a Header and Array of Rows and converts them to a valid CSV formatted String
  # Example:
  # ```
  # CsvShaper::Encoder.new(@header, @rows).to_csv
  # ```
  class Encoder
    def initialize(header, rows = [])
      if header.nil?
        raise MissingHeadersError, 'you must define some headers using csv.headers ...'
      end
      
      @header = header
      @rows = rows
    end
    
    # Public: converts the Shaper mapped headers and rows into
    # a CSV String
    #
    # Returns a String
    def to_csv
      rows = padded_rows.map do |data|
        CSV::Row.new(@header.mapped_columns, data, false)
      end

      table = CSV::Table.new(rows)
      table.to_csv(options)
    end
    
    private

    def options
      CsvShaper::Shaper.config && CsvShaper::Shaper.config.options || {}
    end

    # Internal: make use of `CSV#values_at` to pad out the
    # cells into the correct columns for the headers
    #
    # Returns an Array of Arrays
    def padded_rows
      rows = @rows.map do |row|
        CSV::Row.new(row.cells.keys, row.cells.values)
      end
      
      table = CSV::Table.new(rows)
      table.values_at(*@header.columns)
    end
  end
end
