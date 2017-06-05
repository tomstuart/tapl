require 'builder'

module TermHelpers
  def abs(parameter_name, parameter_type, body)
    Builder.new.build_abstraction(parameter_name.to_s, parameter_type, body)
  end

  def app(left, right)
    Builder.new.build_application(left, right)
  end

  def cond(condition, consequent, alternative)
    Builder.new.build_if(condition, consequent, alternative)
  end

  def fls
    Builder.new.build_boolean(false)
  end

  def is_zero(term)
    Builder.new.build_is_zero(term)
  end

  def pred(term)
    Builder.new.build_pred(term)
  end

  def seq(first, second)
    Builder.new.build_sequence(first, second)
  end

  def succ(term)
    Builder.new.build_succ(term)
  end

  def tru
    Builder.new.build_boolean(true)
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
