require 'typechecker'

module TypecheckingHelpers
  TypecheckingError = Typechecker::Error

  def type_of(term, context)
    Typechecker.type_of(term, context)
  end
end
