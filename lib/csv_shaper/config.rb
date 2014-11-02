require 'csv'

module CsvShaper
  # Config
  # Configure the standard CSV default options
  # as well the option to output the header row

  class Config
    CUSTOM_DEFAULT_OPTIONS = { header_inflector: :humanize }

    attr_reader :options

    def initialize
      @options = {}
      @options.merge!(CUSTOM_DEFAULT_OPTIONS)
      yield self if block_given?
    end

    # Public: set options where the method name
    # matches a key
    def method_missing(meth, value)
      meth = sanitize_setter_method(meth)

      if defaults.key?(meth)
        @options[meth] = value
      else
        super
      end
    end

    def respond_to?(meth)
      meth = sanitize_setter_method(meth)
      defaults.key?(meth)
    end

    private

    # Internal: removes the equals from the end of the
    # method name
    #
    # `meth` - Symbol of the method of sanitize
    #
    # Returns a Symbol
    def sanitize_setter_method(meth)
      meth = meth.to_s.gsub('=', '')
      meth.to_sym
    end

    # Internal: default CSV options, plus a write headers
    # option, to pass to #to_csv
    #
    # Returns a Hash
    def defaults
      @defaults ||= CSV::DEFAULT_OPTIONS.dup.
        merge(write_headers: true).
        merge(CUSTOM_DEFAULT_OPTIONS)
    end
  end
end
