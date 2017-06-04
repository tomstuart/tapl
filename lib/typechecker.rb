require 'term'
require 'type'

module Typechecker
  Error = Class.new(StandardError)

  def self.type_of(term)
    case term
    when Term::False, Term::True
      Type::Boolean
    else
      fail "can’t typecheck #{term}"
    end
  end
end
