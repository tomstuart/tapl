require 'term'
require 'type'

module Typechecker
  Error = Class.new(StandardError)

  def self.type_of(term, context)
    case term
    when Term::Abstraction
      Type::Function.new(term.parameter_type, type_of(term.body, context.extend(term.parameter_name, term.parameter_type)))
    when Term::Application
      function_type = type_of(term.left, context)
      argument_type = type_of(term.right, context)
      raise Error, "#{term.left} isn’t a function" unless function_type.is_a?(Type::Function)
      raise Error, "#{term.right} isn’t a #{function_type.input}" unless argument_type == function_type.input
      function_type.output
    when Term::False, Term::True
      Type::Boolean
    when Term::If
      condition_type = type_of(term.condition, context)
      consequent_type = type_of(term.consequent, context)
      alternative_type = type_of(term.alternative, context)
      raise Error, "#{term.condition} isn’t a boolean" unless condition_type == Type::Boolean
      raise Error, "#{term.consequent} and #{term.alternative} have mismatching types" unless consequent_type == alternative_type
      consequent_type
    when Term::IsZero
      term_type = type_of(term.term, context)
      raise Error, "#{term.term} isn’t a natural number" unless term_type == Type::NaturalNumber
      Type::Boolean
    when Term::Pred, Term::Succ
      term_type = type_of(term.term, context)
      raise Error, "#{term.term} isn’t a natural number" unless term_type == Type::NaturalNumber
      Type::NaturalNumber
    when Term::Unit
      Type::Unit
    when Term::Variable
      type = context.lookup(term.name)
      raise Error, "unknown variable #{term.name}" if type.nil?
      type
    when Term::Zero
      Type::NaturalNumber
    else
      fail "can’t typecheck #{term}"
    end
  end
end
