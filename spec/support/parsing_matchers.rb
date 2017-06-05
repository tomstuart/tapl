require 'support/parsing_helpers'

module ParsingMatchers
  RSpec::Matchers.define :parse do
    include ParsingHelpers

    match do |string|
      actual_term = parse_term(string) rescue nil
      actual_type = parse_type(string) rescue nil

      expect([actual_term, actual_type]).to include a_truthy_value
      expect(expected_term_or_type).to be_nil.or eq(actual_term).or eq(actual_type)
    end

    chain :as, :expected_term_or_type
  end
end

