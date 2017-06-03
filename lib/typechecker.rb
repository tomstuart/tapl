require 'term'
require 'type'

module Typechecker
  Error = Class.new(StandardError)

  def self.type_of(term)
    case term
    when Term::False, Term::True
      Type::Boolean
    when Term::If
      condition_type = type_of(term.condition)
      consequent_type = type_of(term.consequent)
      alternative_type = type_of(term.alternative)
      raise Error, "#{term.condition} isn’t a boolean" unless condition_type == Type::Boolean
      raise Error, "#{term.consequent} and #{term.alternative} have mismatching types" unless consequent_type == alternative_type
      consequent_type
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
