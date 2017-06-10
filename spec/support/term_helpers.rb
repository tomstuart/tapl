require 'builder'

module TermHelpers
  def abs(parameter_name, parameter_type, body)
    Builder.new.build_abstraction(parameter_name.to_s, parameter_type, body)
  end

  def app(left, right)
    Builder.new.build_application(left, right)
  end

  def as(term, type)
    Builder.new.build_ascription(term, type)
  end

  def cas(term, left_name, left_term, right_name, right_term)
    Builder.new.build_case(term, left_name.to_s, left_term, right_name.to_s, right_term)
  end

  def cond(condition, consequent, alternative)
    Builder.new.build_if(condition, consequent, alternative)
  end

  def fls
    Builder.new.build_boolean(false)
  end

  def inl(term, type)
    Builder.new.build_in_left(term, type)
  end

  def inr(term, type)
    Builder.new.build_in_right(term, type)
  end

  def is_zero(term)
    Builder.new.build_is_zero(term)
  end

  def let(definition_name, definition_term, body)
    Builder.new.build_let(definition_name.to_s, definition_term, body)
  end

  def pair(first, second)
    Builder.new.build_pair(first, second)
  end

  def pred(term)
    Builder.new.build_pred(term)
  end

  def proj(term, index)
    Builder.new.build_projection(term, index.to_s)
  end

  def record(*fields)
    builder = Builder.new
    builder.build_record(fields.map { |label, term| builder.build_record_field(label.to_s, term) })
  end

  def seq(first, second)
    Builder.new.build_sequence(first, second)
  end

  def succ(term)
    Builder.new.build_succ(term)
  end

  def tag(label, term, type)
    Builder.new.build_tagging(label.to_s, term, type)
  end

  def tru
    Builder.new.build_boolean(true)
  end

  def tuple(*terms)
    Builder.new.build_tuple(terms)
  end

  def unit
    Builder.new.build_unit
  end

  def var(name)
    Builder.new.build_variable(name.to_s)
  end

  def zero
    Builder.new.build_zero
  end
end
