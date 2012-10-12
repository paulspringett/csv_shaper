# CsvShaperTemplate
# Rails view template class
class CsvShaperTemplate < CsvShaper::Shaper
  # Expected `encode` call
  # Instantiates a new CsvShaperTemplate object and calls `to_csv` on it
  def self.encode(context)
    new(context).tap { |shaper| yield shaper }.to_csv
  end

  def initialize(context)
    @context = context
    super()
  end
end

# CsvShaperHandler
# Template handler for Rails
class CsvShaperHandler
  cattr_accessor :default_format
  self.default_format = Mime::CSV

  # Expected `call` class method
  # Set response headers with filename
  # Primarily calls CsvShaperTemplate.encode, passing through the context (self)
  def self.call(template)
    %{
      unless controller.nil? || (defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base))
        @filename ||= "\#{controller.action_name}.csv"
        controller.response.headers["Content-Type"] ||= 'text/csv'
        controller.response.headers['Content-Disposition'] = "attachment; filename=\\\"\#{@filename}\\\""
      end

      CsvShaperTemplate.encode(self) do |csv|
        #{template.source}
      end
    }
  end
end

ActionView::Template.register_template_handler :shaper, CsvShaperHandler
