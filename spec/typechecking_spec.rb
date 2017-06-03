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
      expect('f (if false then true else false)').to typecheck.as('Bool').in(f: 'Bool → Bool')
    end

    example do
      expect('λx:Bool.f (if x then false else x)').to typecheck.as('Bool → Bool').in(f: 'Bool → Bool')
    end

    example do
      expect('if pred 0 then true else false').not_to typecheck
    end

    example do
      expect('if true then 0 else false').not_to typecheck
    end

    example do
      expect('if x then true else false').not_to typecheck.in(x: 'Bool → Bool')
    end

    example do
      expect('if true then x else y').not_to typecheck.in(x: 'Bool', y: 'Bool → Bool')
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

  describe 'abstractions and applications' do
    example do
      expect('λx:Bool.x').to typecheck.as('Bool → Bool')
    end

    example do
      expect('(λx:Bool.x) true').to typecheck.as('Bool')
    end

    example do
      expect('true true').not_to typecheck
    end

    example do
      expect('(λx:Bool.x) λx:Bool.x').not_to typecheck
    end
  end

  describe 'unit' do
    example do
      expect('λx:Bool.unit').to typecheck.as('Bool → Unit')
    end
  end

  describe 'sequences' do
    example do
      expect('unit; true').to typecheck.as('Bool')
    end

    example do
      expect('true; unit').not_to typecheck
    end
  end

  describe 'wildcards' do
    example do
      expect('λ_:Bool._').to typecheck.as('Bool → Unit').in(_: 'Unit')
    end
  end

  describe 'ascriptions' do
    example do
      expect('true as Bool').to typecheck.as('Bool')
    end

    example do
      expect('true as Unit').not_to typecheck
    end
  end

  describe 'let' do
    example do
      expect('let f = λx:Bool.x in f true').to typecheck.as('Bool')
    end

    example do
      expect('let f = true in f true').not_to typecheck
    end
  end
end
