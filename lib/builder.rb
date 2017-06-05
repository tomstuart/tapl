require 'term'
require 'type'

class Builder
  def build_boolean(value)
    value ? Term::True : Term::False
  end

  def build_type_boolean
    Type::Boolean
  end
end
