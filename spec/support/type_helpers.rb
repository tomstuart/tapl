require 'builder'

module TypeHelpers
  def bool
    Builder.new.build_type_boolean
  end

  def func(input, output)
    Builder.new.build_type_function(input, output)
  end

  def list(type)
    Builder.new.build_type_list(type)
  end

  def nat
    Builder.new.build_type_natural_number
  end

  def prod(first, second)
    Builder.new.build_type_product(first, second)
  end

  def record_type(fields)
    builder = Builder.new
    builder.build_type_record(fields.map { |label, type| builder.build_type_record_field(label.to_s, type) })
  end

  def sum(left, right)
    Builder.new.build_type_sum(left, right)
  end

  def tuple_type(*types)
    Builder.new.build_type_tuple(types)
  end

  def variant(fields)
    builder = Builder.new
    builder.build_type_variant(fields.map { |label, type| builder.build_type_variant_field(label.to_s, type) })
  end

  def void
    Builder.new.build_type_unit
  end
end
