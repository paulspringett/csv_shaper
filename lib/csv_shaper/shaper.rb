module CsvShaper
  # Shaper
  # Core CsvShaper class. Delegates header and row generating.
  class Shaper
    attr_reader :header, :rows

    def self.config
      @config ||= Config.new
    end

    def self.config=(new_config)
      @config = new_config
    end

    def initialize(options = {})
      @rows = []
      local_configuration(options)
      yield self if block_given?
    end

    # Public: creates a new instance of Shaper taps it with
    # with the given block and encodes it to a String of CSV data
    # Example:
    # ```
    # data = CsvShaper::Shaper.encode do |csv|
    #   csv.rows @users do |csv, user|
    #     csv.cells :name, :age, :gender
    #   end
    # end
    #
    # puts data
    # => "Name,Age,Gender\n'Joe Bloggs',25,'M'\n'John Smith',34,'M'"
    # ```
    #
    # Returns a String
    def self.encode(options = {})
      new(options).tap { |shaper| yield shaper }.to_csv
    end

    # Public: creates a header row for the CSV
    # This is delegated to the Header class
    # see header.rb for usage examples
    #
    # Returns a Header instance
    def headers(*args, &block)
      @header = Header.new(*args, &block)
    end

    # Public: adds a row to the CSV
    # This is delegated to the Row class
    # See row.rb for usage examples
    #
    # Returns an updated Array of Row objects
    def row(*args, &block)
      @rows.push Row.new(*args, &block)
    end

    # Public: adds several rows to the CSV
    #
    # `collection` - an Enumerable of objects to be passed to #row
    #
    # Returns an updated Array of Row objects
    def rows(collection = nil, &block)
      return @rows if collection.nil?

      unless collection.respond_to?(:each)
        raise ArgumentError, 'csv.rows only accepts Enumerable object (that respond to #each). Use csv.row for a single object.'
      end

      collection.each do |element|
        row(element, &block)
      end

      @rows
    end

    # Public: converts the Header and Row objects into a string
    # of valid CSV data. Delegated to the Encoder class
    #
    # Returns a String
    def to_csv
      Encoder.new(@header, @rows).to_csv(@local_config)
    end

    # Public: Create an instance of the config and cache it
    # for reference by the Encoder later
    def self.configure(&block)
      @config ||= CsvShaper::Config.new(&block)
    end

    private

    def local_configuration(options = {})
      @local_config = CsvShaper::Config.new do |csv|
        options.each_pair { |k, v| csv.send("#{k}=", v) }
      end
    end
  end
end
