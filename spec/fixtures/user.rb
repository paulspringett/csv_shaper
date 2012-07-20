class User
  attr_accessor :name, :age, :gender
  
  def self.attribute_names
    [:name, :age, :gender]
  end
end