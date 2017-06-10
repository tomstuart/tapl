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

  def build_let(definition_name, definition_term, body)
    Term::Let.new(definition_name, definition_term, body)
  end

  def build_pair(first, second)
    Term::Pair.new(first, second)
  end

  def build_projection(term, index)
    Term::Projection.new(term, index)
  end

  def build_tuple(terms)
    Term::Tuple.new(terms)
  end

  def build_record_field(label, term)
    Term::Record::Field.new(label, term)
  end

  def build_record(fields)
    Term::Record.new(fields)
  end

  def build_in_left(term, type)
    Term::InLeft.new(term, type)
  end

  def build_in_right(term, type)
    Term::InRight.new(term, type)
  end

  def build_case(term, left_name, left_term, right_name, right_term)
    Term::Case.new(term, left_name, left_term, right_name, right_term)
  end

  def build_tagging(label, term, type)
    Term::Tagging.new(label, term, type)
  end

  def build_variant_case_case(label, name, term)
    Term::VariantCase::Case.new(label, name, term)
  end

  def build_variant_case(term, cases)
    Term::VariantCase.new(term, cases)
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

  def build_type_product(first, second)
    Type::Product.new(first, second)
  end

  def build_type_tuple(types)
    Type::Tuple.new(types)
  end

  def build_type_record_field(label, type)
    Type::Record::Field.new(label, type)
  end

  def build_type_record(fields)
    Type::Record.new(fields)
  end

  def build_type_sum(left, right)
    Type::Sum.new(left, right)
  end

  def build_type_variant_field(label, type)
    Type::Variant::Field.new(label, type)
  end

  def build_type_variant(fields)
    Type::Variant.new(fields)
  end
end
