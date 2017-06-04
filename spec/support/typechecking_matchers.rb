require 'support/parsing_helpers'
require 'support/typechecking_helpers'

module TypecheckingMatchers
  RSpec::Matchers.define :typecheck do
    include ParsingHelpers
    include TypecheckingHelpers

    match notify_expectation_failures: true do |term|
      term = parse_term(term)
      @expected_type = parse_type(@expected_type) unless @expected_type.nil?

      begin
        actual_type = type_of(term)
      rescue TypecheckingHelpers::TypecheckingError => e
        @message = e.message
        return false
      end

      expect(actual_type).not_to be_nil
      expect(@expected_type).to be_nil.or eq(actual_type)
    end

    failure_message do |term|
      @message
    end

    chain :as, :expected_type
  end
end
