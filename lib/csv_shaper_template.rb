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
      CsvShaperTemplate.encode(self) do |csv|
        #{template.source}
      end
    }
  end
end

if defined?(Rails)
  ActionView::Template.register_template_handler :shaper, CsvShaperHandler
end
