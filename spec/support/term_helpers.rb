require 'builder'

module TermHelpers
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

  def succ(term)
    Builder.new.build_succ(term)
  end

  def tru
    Builder.new.build_boolean(true)
  end

  def zero
    Builder.new.build_zero
  end
end
