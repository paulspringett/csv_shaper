module CsvShaper
  class Shaper < BlankSlate
    
    attr_reader :head, :rows
    
    def initialize
      @rows = []
    end
    
    def self.encode
      new.tap { |shaper| yield shaper }
    end
    
    def header(*args, &block)
      @head = Header.build(*args, &block)
    end
    
    def row(*args, &block)
      row = Row.new(*args, &block)
      @rows.push(row)
    end
    
    def rows(collection, &block)
      collection.each do |element|
        row(element, &block)
      end
    end
    
    def encode!
      Encoder.new(@header, @rows)
    end
    
  end
end
