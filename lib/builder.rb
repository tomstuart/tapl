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

  def build_type_boolean
    Type::Boolean
  end

  def build_type_natural_number
    Type::NaturalNumber
  end
end
