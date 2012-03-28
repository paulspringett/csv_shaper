module CsvShaper
  class Header < BlankSlate

    attr_reader :klass, :columns, :mappings, :mapped_columns

    def self.build(*args)      
      header = new(*args)
      
      if block_given?
        header.tap { |header| yield header }
      elsif header.klass && header.columns.empty?
        header.columns(header.klass.attribute_names)
      end
      
      header
    end
    
    def initialize(klass, columns = [])
      @klass = klass
      @columns = columns
      @mappings = {}
    end
    
    def mappings(hash = {}) 
      @mappings.merge!(hash)
      puts "mappings: #{@mappings.inspect}"
    end
    
    def columns(*args)
      @columns = args.map(&:to_sym)
    end
    
    def mapped_columns
      @columns.map do |column|
        @mappings[column] || column.to_s.humanize
      end
    end

  end
end
