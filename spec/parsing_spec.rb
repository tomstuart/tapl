require 'support/parsing_matchers'
require 'support/term_helpers'
require 'support/type_helpers'
require 'term'
require 'type'

RSpec.describe 'parsing' do
  include ParsingMatchers
  include TermHelpers
  include TypeHelpers

  describe 'booleans' do
    example do
      expect('Bool').to parse.as bool
    end

    example do
      expect('true').to parse.as tru
    end

    example do
      expect('false').to parse.as fls
    end
  end
end
