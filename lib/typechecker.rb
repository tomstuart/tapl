require 'term'
require 'type'

module Typechecker
  Error = Class.new(StandardError)

  def self.type_of(term)
    case term
    when Term::False, Term::True
      Type::Boolean
    when Term::IsZero
      term_type = type_of(term.term)
      raise Error, "#{term.term} isn’t a natural number" unless term_type == Type::NaturalNumber
      Type::Boolean
    when Term::Pred, Term::Succ
      term_type = type_of(term.term)
      raise Error, "#{term.term} isn’t a natural number" unless term_type == Type::NaturalNumber
      Type::NaturalNumber
    when Term::Zero
      Type::NaturalNumber
    else
      fail "can’t typecheck #{term}"
    end
  end
end
