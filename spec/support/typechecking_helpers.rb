require 'typechecker'

module TypecheckingHelpers
  TypecheckingError = Typechecker::Error

  def type_of(term)
    Typechecker.type_of(term)
  end
end
