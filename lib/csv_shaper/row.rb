module CsvShaper
  class Row < BlankSlate
    
    attr_accessor :model, :attributes, :cells
    
    def initialize(*args)
      @cells = ActiveSupport::OrderedHash.new
      
      case
      # csv.row @user do |csv, user|
      when args.one? && block_given?
        @model = args.first
        yield self, @model
      
      # csv.row do |csv|
      when args.emtpy? && block_given?
        yield self
      
      # csv.row @user, :name, :age, :location
      when args.many?
        @model = args.pop
        args.each { |col| cell(col) }
      end        
    end
    
    def cells(*args)
      args.each { |col| cell(col) }
    end
    
    def cell(column, options = {})
      column = column.to_sym
      @attributes.push(column) unless @attributes.include?(column)
      @cells[column] = @model.send(column)
    end
    
  end
end
