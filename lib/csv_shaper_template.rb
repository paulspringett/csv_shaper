class CsvShaperTemplate < CsvShaper::Shaper
  def self.encode(context)
    new(context).tap { |shaper| yield shaper }.to_csv
  end

  def initialize(context)
    @context = context
    super()
  end
end

class CsvShaperHandler
  cattr_accessor :default_format
  self.default_format = Mime::CSV

  def self.call(template)
    %{
      unless defined?(ActionMailer) && defined?(ActionMailer::Base) && controller.is_a?(ActionMailer::Base)
        @filename ||= "\#{controller.action_name}.csv"
        controller.response.headers["Content-Type"] ||= 'text/csv'
        controller.response.headers['Content-Disposition'] = "attachment; filename='\#{@filename}'"
      end

      CsvShaperTemplate.encode(self) do |csv|
        #{template.source}
      end
    }
  end
end

ActionView::Template.register_template_handler :shaper, CsvShaperHandler
