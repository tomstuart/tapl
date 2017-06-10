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

  describe 'natural numbers' do
    example do
      expect('Nat').to parse.as nat
    end
  end

  describe 'natural numbers' do
    example do
      expect('0').to parse.as zero
    end

    example do
      expect('pred 0').to parse.as pred(zero)
    end

    example do
      expect('succ (pred 0)').to parse.as succ(pred(zero))
    end

    example do
      expect('iszero (succ (pred 0))').to parse.as is_zero(succ(pred(zero)))
    end

    example do
      expect('pred (iszero 0)').to parse.as pred(is_zero(zero))
    end

    example do
      expect('iszero (iszero 0)').to parse.as is_zero(is_zero(zero))
    end

    example do
      expect('Nat').to parse.as nat
    end
  end
end
