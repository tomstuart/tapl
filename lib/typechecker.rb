require 'term'
require 'type'

module Typechecker
  Error = Class.new(StandardError)

  def self.type_of(term, context)
    case term
    when Term::Abstraction
      if term.parameter_name == Term::WILDCARD
        type_of(Term.desugar(term), context)
      else
        Type::Function.new(term.parameter_type, type_of(term.body, context.extend(term.parameter_name, term.parameter_type)))
      end
    when Term::Application
      function_type = type_of(term.left, context)
      argument_type = type_of(term.right, context)
      raise Error, "#{term.left} isn’t a function" unless function_type.is_a?(Type::Function)
      raise Error, "#{term.right} isn’t a #{function_type.input}" unless argument_type == function_type.input
      function_type.output
    when Term::Ascription
      type_of(Term.desugar(term), context)
    when Term::Case
      sum_type = type_of(term.term, context)
      raise Error, "#{term.term} isn’t a sum" unless sum_type.is_a?(Type::Sum)
      left_type = type_of(term.left_term, context.extend(term.left_name, sum_type.left))
      right_type = type_of(term.right_term, context.extend(term.right_name, sum_type.right))
      raise Error, "#{term.left_term} and #{term.right_term} have mismatching types" unless left_type == right_type
      left_type
    when Term::False, Term::True
      Type::Boolean
    when Term::Fix
      function_type = type_of(term.term, context)
      raise Error, "#{term.term} isn’t a function" unless function_type.is_a?(Type::Function)
      raise Error, "#{term.term} has mismatched input and output types" unless function_type.input == function_type.output
      function_type.input
    when Term::If
      condition_type = type_of(term.condition, context)
      consequent_type = type_of(term.consequent, context)
      alternative_type = type_of(term.alternative, context)
      raise Error, "#{term.condition} isn’t a boolean" unless condition_type == Type::Boolean
      raise Error, "#{term.consequent} and #{term.alternative} have mismatching types" unless consequent_type == alternative_type
      consequent_type
    when Term::InLeft, Term::InRight
      raise Error, "#{term.type} isn’t a sum type" unless term.type.is_a?(Type::Sum)
      term_type = type_of(term.term, context)
      expected_type =
        case term
        when Term::InLeft
          term.type.left
        when Term::InRight
          term.type.right
        end
      raise Error, "#{term.term} isn’t a #{expected_type}" unless term_type == expected_type
      term.type
    when Term::IsZero
      term_type = type_of(term.term, context)
      raise Error, "#{term.term} isn’t a natural number" unless term_type == Type::NaturalNumber
      Type::Boolean
    when Term::Pred, Term::Succ
      term_type = type_of(term.term, context)
      raise Error, "#{term.term} isn’t a natural number" unless term_type == Type::NaturalNumber
      Type::NaturalNumber
    when Term::Let
      definition_type = type_of(term.definition_term, context)
      type_of(term.body, context.extend(term.definition_name, definition_type))
    when Term::LetRec
      type_of(Term.desugar(term), context)
    when Term::Pair
      first_type = type_of(term.first, context)
      second_type = type_of(term.second, context)
      Type::Product.new(first_type, second_type)
    when Term::Projection
      type = type_of(term.term, context)
      case type
      when Type::Product
        index = Integer(term.index)
        raise Error, 'index out of bounds' unless (1..2).include?(index)
        case index
        when 1
          type.first
        when 2
          type.second
        end
      when Type::Tuple
        index = Integer(term.index)
        raise Error, 'index out of bounds' unless (1..type.types.length).include?(index)
        type.types[index.pred]
      when Type::Record
        field = type.field(term.index)
        raise Error, 'label not found' if field.nil?
        field.type
      else
        raise Error, "can’t project from a #{type}"
      end
    when Term::Record
      labels = term.fields.map(&:label)
      raise Error, 'duplicate label' unless labels.uniq.length == labels.length
      fields = term.fields.map { |field|
        Type::Record::Field.new(field.label, type_of(field.term, context))
      }
      Type::Record.new(fields)
    when Term::Sequence
      type_of(Term.desugar(term), context)
    when Term::Tagging
      variant_type = term.type
      raise Error, "#{variant_type} isn’t a variant type" unless variant_type.is_a?(Type::Variant)
      field = variant_type.field(term.label)
      raise Error, 'label not found' if field.nil?
      term_type = type_of(term.term, context)
      raise Error, "#{term.term} isn’t a #{field.type}" unless term_type == field.type
      term.type
    when Term::Tuple
      types = term.terms.map { |term| type_of(term, context) }
      Type::Tuple.new(types)
    when Term::Unit
      Type::Unit
    when Term::Variable
      type = context.lookup(term.name)
      raise Error, "unknown variable #{term.name}" if type.nil?
      type
    when Term::VariantCase
      variant_type = type_of(term.term, context)
      raise Error, "#{term.term} isn’t a variant" unless variant_type.is_a?(Type::Variant)
      type_labels = variant_type.fields.map(&:label)
      case_labels = term.cases.map(&:label)
      missing_labels = type_labels - case_labels
      unknown_labels = case_labels - type_labels
      raise Error, 'missing label' unless missing_labels.empty?
      raise Error, 'unknown label' unless unknown_labels.empty?
      raise Error, 'duplicate label' unless case_labels.length == type_labels.length
      case_types = term.cases.map { |kase|
        field = variant_type.field(kase.label)
        type_of(kase.term, context.extend(kase.name, field.type))
      }
      raise Error, 'cases have mismatching types' unless case_types.uniq.length == 1
      case_types.first
    when Term::Zero
      Type::NaturalNumber
    else
      fail "can’t typecheck #{term}"
    end
  end
end
