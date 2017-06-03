require 'context'
require 'support/parsing_helpers'

module ContextHelpers
  include ParsingHelpers

  def empty_context
    Context.new
  end

  def assume(assumptions)
    assumptions.inject(empty_context) { |context, (name, type)|
      type = parse_type(type)
      context.extend(name.to_s, type)
    }
  end
end
