require 'active_support/ordered_hash'
require 'active_support/inflector'

require 'csv_shaper/version'
require 'csv_shaper/header'
require 'csv_shaper/row'
require 'csv_shaper/encoder'
require 'csv_shaper/config'
require 'csv_shaper/shaper'

module CsvShaper
  class MissingHeadersError < StandardError; end

  # Shortcut the encode method
  def self.encode(options = {}, &block)
    CsvShaper::Shaper.encode(options, &block)
  end

  def self.configure(&block)
    CsvShaper::Shaper.configure(&block)
  end
end

require "csv_shaper_handler" if defined?(ActionView::Template)
