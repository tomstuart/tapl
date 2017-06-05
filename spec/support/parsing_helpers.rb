require 'builder'
require 'parser'

module ParsingHelpers
  def parse_term(string)
    Parser.new(Builder.new).parse_complete_term(string)
  end

  def parse_type(string)
    Parser.new(Builder.new).parse_complete_type(string)
  end
end
