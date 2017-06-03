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

  describe 'conditionals' do
    example do
      expect('if false then true else false').to typecheck.as('Bool')
    end

    example do
      expect('if true then 0 else succ 0').to typecheck.as('Nat')
    end

    example do
      expect('if pred 0 then true else false').not_to typecheck
    end

    example do
      expect('if true then 0 else false').not_to typecheck
    end
  end

  describe 'variables' do
    example do
      expect('x').to typecheck.as('Bool').in(x: 'Bool')
    end

    example do
      expect('x').not_to typecheck
    end
  end
end
