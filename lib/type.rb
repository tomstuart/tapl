module Type
  Boolean = Object.new
  Function = Struct.new(:input, :output)
  NaturalNumber = Object.new
  Product = Struct.new(:first, :second)
  Tuple = Struct.new(:types)
  Unit = Object.new
end
