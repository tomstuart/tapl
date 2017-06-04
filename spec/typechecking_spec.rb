require 'support/typechecking_matchers'

RSpec.describe 'typechecking' do
  include TypecheckingMatchers

  describe 'booleans' do
    example do
      expect('true').to typecheck.as('Bool')
    end

    example do
      expect('false').to typecheck.as('Bool')
    end
  end

  describe 'natural numbers' do
    example do
      expect('0').to typecheck.as('Nat')
    end

    example do
      expect('pred 0').to typecheck.as('Nat')
    end

    example do
      expect('succ (pred 0)').to typecheck.as('Nat')
    end

    example do
      expect('iszero (succ (pred 0))').to typecheck.as('Bool')
    end

    example do
      expect('pred (iszero 0)').not_to typecheck
    end

    example do
      expect('iszero (iszero 0)').not_to typecheck
    end
  end
end
