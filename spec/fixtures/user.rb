class User
  attr_accessor :name, :age, :gender
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def self.attribute_names
    [:name, :age, :gender]
  end
end