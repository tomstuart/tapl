require 'builder'

module TypeHelpers
  def bool
    Builder.new.build_type_boolean
  end

  def nat
    Builder.new.build_type_natural_number
  end
end
