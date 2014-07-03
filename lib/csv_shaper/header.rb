module CsvShaper
  # Header
  # Handles creating and mapping of the headers
  # Examples:
  # ```
  # # assign the headers from the attributes of a class
  # csv.headers User
  #
  # # assigns headers normally
  # csv.headers :name, :age, :location
  #
  # # pass a block
  # csv.headers do |csv|
  #   csv.columns :name, :age, :location
  #   csv.mappings name: 'Full name, location: 'Region'
  # end
  # ```
  class Header
    attr_reader :klass, :mappings, :mapped_columns, :inflector

    def initialize(*args)
      @mappings = {}
      @columns = []
      @inflector = CsvShaper::Shaper.config.options[:header_inflector]

      if block_given?
        yield self
      elsif args.any?
        if (@klass = args.first.respond_to?(:attribute_names) && args.first)
          columns(*@klass.attribute_names)
        else
          columns(*args)
        end
      end
    end

    # Public: serves as the getter and setter for the Array
    # of Symbol column names. Union join the existing column
    # names with those passed
    # Example:
    # ```
    # header.columns :name, :age, :location
    # ```
    # `args` - Array of Symbol arguments passed
    #
    # Returns as Array of Symbols
    def columns(*args)
      @columns = @columns | args.map(&:to_sym)
    end

    # Public: Define mappings of the Symbol column names
    # to nicer, human names
    # Example:
    # ```
    # header.mappings name: 'Full name', age: 'Age of person'
    # ```
    # `hash` - Hash of mappings where the key is the column name to map
    #          and the value is the human readable value
    #
    # Returns a Hash of mappings
    def mappings(hash = {})
      @mappings.merge!(hash)
    end

    # Public: Convert column names, default inflector is :humanize
    # Example:
    # ```
    # header.inflector :titleize
    # ```
    # `:titleize` - one of ruby inflectors
    def inflector(header_inflector)
      @inflector = header_inflector
    end

    # Public: converts columns and mappings into mapped columns
    # ready for encoding. If a mapped value is found that is used,
    # else the Symbol column name is humanized by default or can be specified
    # with header_inflector option
    #
    # Returns an Array of Strings
    def mapped_columns
      @columns.map do |column|
        @mappings[column] || column.to_s.send(@inflector)
      end
    end

  end
end
