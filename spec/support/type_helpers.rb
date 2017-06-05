require 'builder'

module TypeHelpers
  def bool
    Builder.new.build_type_boolean
  end
end
