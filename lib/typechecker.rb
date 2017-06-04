require 'term'
require 'type'

module Typechecker
  Error = Class.new(StandardError)

  def self.type_of(term)
    fail "can’t typecheck #{term}"
  end
end
