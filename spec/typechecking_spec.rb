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

  describe 'pairs' do
    describe 'introduction' do
      example do
        expect('{true, λx:Bool.x}').to typecheck.as('Bool × (Bool → Bool)')
      end
    end

    describe 'elimination' do
      example do
        expect('{true, λx:Bool.x}.1').to typecheck.as('Bool')
      end

      example do
        expect('{true, λx:Bool.x}.2').to typecheck.as('Bool → Bool')
      end

      example do
        expect('(λx:Bool.x).2').not_to typecheck
      end
    end
  end

  describe 'tuples' do
    describe 'introduction' do
      example do
        expect('{unit, true, λx:Bool.unit}').to typecheck.as('{Unit, Bool, Bool → Unit}')
      end
    end

    describe 'elimination' do
      example do
        expect('{unit, true, λx:Bool.unit}.3').to typecheck.as('Bool → Unit')
      end

      example do
        expect('{unit, true, λx:Bool.unit}.0').not_to typecheck
      end

      example do
        expect('{unit, true, λx:Bool.unit}.4').not_to typecheck
      end

      example do
        expect('(λx:Bool.x).1').not_to typecheck
      end
    end
  end

  describe 'records' do
    describe 'introduction' do
      example do
        expect('{x=false, y=λx:Bool.true, z=unit}').to typecheck.as('{x:Bool, y:Bool → Bool, z:Unit}')
      end

      example do
        expect('{x=false, y=λx:Bool.true, x=unit}').not_to typecheck
      end
    end

    describe 'elimination' do
      example do
        expect('{x=false, y=λx:Bool.true, z=unit}.y').to typecheck.as('Bool → Bool')
      end

      example do
        expect('{x=false, y=λx:Bool.true, z=unit}.w').not_to typecheck
      end

      example do
        expect('true.x').not_to typecheck
      end
    end
  end

  describe 'sums' do
    describe 'introduction' do
      example do
        expect('inl true as Bool + Unit').to typecheck.as('Bool + Unit')
      end

      example do
        expect('inr unit as Bool + Unit').to typecheck.as('Bool + Unit')
      end

      example do
        expect('inl unit as Bool + Unit').not_to typecheck
      end

      example do
        expect('inl true as Bool').not_to typecheck
      end
    end

    describe 'elimination' do
      example do
        expect('case inl true as Bool + Unit of inl x ⇒ x | inr y ⇒ y; false').to typecheck.as('Bool')
      end

      example do
        expect('case inl true as Bool + Unit of inl x ⇒ x | inr y ⇒ λz:Bool.y').not_to typecheck
      end

      example do
        expect('case true of inl x ⇒ x | inr y ⇒ y; false').not_to typecheck
      end
    end
  end

  describe 'variants' do
    describe 'introduction' do
      example do
        expect('<some=true> as <none: Unit, some: Bool>').to typecheck.as('<none: Unit, some: Bool>')
      end

      example do
        expect('<some=unit> as <none: Unit, some: Bool>').not_to typecheck
      end

      example do
        expect('<many=false> as <none: Unit, some: Bool>').not_to typecheck
      end

      example do
        expect('<some=true> as Unit × Bool').not_to typecheck
      end
    end

    describe 'elimination' do
      example do
        expect('case <some=true> as <none:Unit, some:Bool> of <none=x> ⇒ false | <some=y> ⇒ y').to typecheck.as('Bool')
      end

      example do
        expect('case true of <none=x> ⇒ false | <some=y> ⇒ y').not_to typecheck
      end

      example do
        expect('case <some=true> as <none:Unit, some:Bool> of <none=x> ⇒ false | <some=y> ⇒ y | <many=z> ⇒ true').not_to typecheck
      end

      example do
        expect('case <some=true> as <none:Unit, some:Bool> of <some=y> ⇒ y').not_to typecheck
      end

      example do
        expect('case <some=true> as <none:Unit, some:Bool> of <none=x> ⇒ false | <some=y> ⇒ y | <some=z> ⇒ z').not_to typecheck
      end

      example do
        expect('case <some=true> as <none:Unit, some:Bool> of <none=x> ⇒ x | <some=y> ⇒ y').not_to typecheck
      end
    end
  end

  describe 'fix' do
    example do
      expect('fix λie:Nat → Bool.λx:Nat.if iszero x then true else if iszero (pred x) then false else ie (pred (pred x))').to typecheck.as('Nat → Bool')
    end

    example do
      expect('fix λieio:{iseven:Nat → Bool, isodd:Nat → Bool}.{iseven=λx:Nat.if iszero x then true else ieio.isodd (pred x), isodd=λx:Nat.if iszero x then false else ieio.iseven (pred x)}').to typecheck.as('{iseven: Nat → Bool, isodd: Nat → Bool}')
    end

    example do
      expect('fix iszero (succ 0)').not_to typecheck
    end

    example do
      expect('fix λx:Nat.iszero x').not_to typecheck
    end
  end

  describe 'letrec' do
    example do
      expect('letrec iseven:Nat → Bool = λx:Nat.if iszero x then true else if iszero (pred x) then false else iseven (pred (pred x)) in iseven (succ (succ (succ 0)))').to typecheck.as('Bool')
    end
  end

  describe 'lists' do
    example do
      expect('nil[Nat]').to typecheck.as('List Nat')
    end

    example do
      expect('cons[Bool] true cons[Bool] false nil[Bool]').to typecheck.as('List Bool')
    end

    example do
      expect('cons[Bool] 0 cons[Bool] false nil[Bool]').not_to typecheck
    end

    example do
      expect('cons[Bool] true cons[Nat] 0 nil[Nat]').not_to typecheck
    end

    example do
      expect('cons[Bool] true false').not_to typecheck
    end

    example do
      expect('isnil[Nat] cons[Nat] 0 nil[Nat]').to typecheck.as('Bool')
    end

    example do
      expect('isnil[Nat] cons[Bool] false nil[Bool]').not_to typecheck
    end

    example do
      expect('isnil[Nat] 0').not_to typecheck
    end

    example do
      expect('head[Nat] cons[Nat] (succ 0) cons[Nat] 0 nil[Nat]').to typecheck.as('Nat')
    end

    example do
      expect('tail[Nat] cons[Nat] (succ 0) cons[Nat] 0 nil[Nat]').to typecheck.as('List Nat')
    end

    example do
      expect('head[Nat] cons[Bool] true nil[Bool]').not_to typecheck
    end

    example do
      expect('tail[Nat] cons[Bool] true nil[Bool]').not_to typecheck
    end

    example do
      expect('head[Nat] 0').not_to typecheck
    end

    example do
      expect('tail[Nat] 0').not_to typecheck
    end
  end
end
