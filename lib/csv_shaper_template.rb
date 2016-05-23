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

  def config
    @local_config
  end
end
