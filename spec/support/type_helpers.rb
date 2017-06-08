require 'builder'

module TypeHelpers
  def bool
    Builder.new.build_type_boolean
  end

  def func(input, output)
    Builder.new.build_type_function(input, output)
  end

  def nat
    Builder.new.build_type_natural_number
  end

  def prod(first, second)
    Builder.new.build_type_product(first, second)
  end

  def tuple_type(*types)
    Builder.new.build_type_tuple(types)
  end

  def void
    Builder.new.build_type_unit
  end
end
