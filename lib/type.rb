module Type
  module Fields
    def field(label)
      fields.detect { |field| field.label == label }
    end
  end

  Boolean = Object.new
  Function = Struct.new(:input, :output)
  NaturalNumber = Object.new
  Product = Struct.new(:first, :second)
  Record = Struct.new(:fields)
  Record.include(Fields)
  Record::Field = Struct.new(:label, :type)
  Tuple = Struct.new(:types)
  Unit = Object.new
end
