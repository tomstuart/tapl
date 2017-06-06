require 'term'
require 'type'

class Builder
  def build_boolean(value)
    value ? Term::True : Term::False
  end

  def build_zero
    Term::Zero
  end

  def build_pred(term)
    Term::Pred.new(term)
  end

  def build_succ(term)
    Term::Succ.new(term)
  end

  def build_is_zero(term)
    Term::IsZero.new(term)
  end

  def build_if(condition, consequent, alternative)
    Term::If.new(condition, consequent, alternative)
  end

  def build_variable(name)
    Term::Variable.new(name)
  end

  def build_abstraction(parameter_name, parameter_type, body)
    Term::Abstraction.new(parameter_name, parameter_type, body)
  end

  def build_application(left, right)
    Term::Application.new(left, right)
  end

  def build_unit
    Term::Unit
  end

  def build_sequence(first, second)
    Term::Sequence.new(first, second)
  end

  def build_ascription(term, type)
    Term::Ascription.new(term, type)
  end

  def build_type_boolean
    Type::Boolean
  end

  def build_type_natural_number
    Type::NaturalNumber
  end

  def build_type_function(input, output)
    Type::Function.new(input, output)
  end

  def build_type_unit
    Type::Unit
  end
end
