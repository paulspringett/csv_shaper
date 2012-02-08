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
    
    def row
      @rows << "foo"
    end
    
    def encode!
      Encoder.new(@header, @rows)
    end
    
  end
end
