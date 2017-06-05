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
end
