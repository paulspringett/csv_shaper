require 'csv_shaper_template'

# CsvShaperHandler
# Template handler for Rails
class CsvShaperHandler
  cattr_accessor :default_format
  self.default_format = Mime[:csv]

  # Expected `call` class method
  # Set response headers with filename
  # Primarily calls CsvShaperTemplate.encode, passing through the context (self)
  def self.call(template)
    %{
      if ( controller.present? ) && !( defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base) )
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
