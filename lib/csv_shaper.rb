require 'blankslate'
require 'active_support/ordered_hash'
require 'active_support/inflector'

require 'csv_shaper/version'
require 'csv_shaper/header'
require 'csv_shaper/row'
require 'csv_shaper/encoder'
require 'csv_shaper/shaper'

module CsvShaper
  class MissingHeadersError < StandardError; end
end

require "csv_shaper_template" if defined?(ActionView::Template)
