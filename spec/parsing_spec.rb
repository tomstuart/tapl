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

  describe 'conditionals' do
    example do
      expect('if false then true else false').to parse.as cond(fls, tru, fls)
    end

    example do
      expect('if true then 0 else succ 0').to parse.as cond(tru, zero, succ(zero))
    end

    example do
      expect('if pred 0 then true else false').to parse.as cond(pred(zero), tru, fls)
    end

    example do
      expect('if true then 0 else false').to parse.as cond(tru, zero, fls)
    end
  end

  describe 'variables' do
    example do
      expect('x').to parse.as var(:x)
    end
  end

  describe 'functions' do
    example do
      expect('Bool → Bool').to parse.as func(bool, bool)
    end

    example do
      expect('Bool → Nat → Bool').to parse.as func(bool, func(nat, bool))
    end

    example do
      expect('(Bool → Nat) → Bool').to parse.as func(func(bool, nat), bool)
    end
  end

  describe 'abstractions and applications' do
    example do
      expect('f (if false then true else false)').to parse.as app(var(:f), cond(fls, tru, fls))
    end

    example do
      expect('λx:Bool.f (if x then false else x)').to parse.as abs(:x, bool, app(var(:f), cond(var(:x), fls, var(:x))))
    end

    example do
      expect('if x then true else false').to parse.as cond(var(:x), tru, fls)
    end

    example do
      expect('if true then x else y').to parse.as cond(tru, var(:x), var(:y))
    end

    example do
      expect('λx:Bool.x').to parse.as abs(:x, bool, var(:x))
    end

    example do
      expect('(λx:Bool.x) true').to parse.as app(abs(:x, bool, var(:x)), tru)
    end

    example do
      expect('true true').to parse.as app(tru, tru)
    end

    example do
      expect('(λx:Bool.x) λx:Bool.x').to parse.as app(abs(:x, bool, var(:x)), abs(:x, bool, var(:x)))
    end
  end

  describe 'unit' do
    example do
      expect('Bool → Unit').to parse.as func(bool, void)
    end

    example do
      expect('λx:Bool.unit').to parse.as abs(:x, bool, unit)
    end
  end

  describe 'sequences' do
    example do
      expect('unit; true').to parse.as seq(unit, tru)
    end

    example do
      expect('true; unit').to parse.as seq(tru, unit)
    end
  end

  describe 'wildcards' do
    example do
      expect('λ_:Bool._').to parse.as abs(:_, bool, var(:_))
    end
  end

  describe 'ascriptions' do
    example do
      expect('true as Bool').to parse.as as(tru, bool)
    end

    example do
      expect('true as Unit').to parse.as as(tru, void)
    end
  end

  describe 'let' do
    example do
      expect('let f = λx:Bool.x in f true').to parse.as let(:f, abs(:x, bool, var(:x)), app(var(:f), tru))
    end

    example do
      expect('let f = true in f true').to parse.as let(:f, tru, app(var(:f), tru))
    end
  end

  describe 'pairs' do
    example do
      expect('Bool × Bool → Bool').to parse.as func(prod(bool, bool), bool)
    end

    example do
      expect('Bool × (Bool → Bool)').to parse.as prod(bool, func(bool, bool))
    end

    example do
      expect('{true, λx:Bool.x}').to parse.as pair(tru, abs(:x, bool, var(:x)))
    end

    example do
      expect('{true, λx:Bool.x}.1').to parse.as proj(pair(tru, abs(:x, bool, var(:x))), 1)
    end

    example do
      expect('{true, λx:Bool.x}.2').to parse.as proj(pair(tru, abs(:x, bool, var(:x))), 2)
    end

    example do
      expect('(λx:Bool.x).2').to parse.as proj(abs(:x, bool, var(:x)), 2)
    end
  end

  describe 'tuples' do
    example do
      expect('{Unit, Bool, Bool → Unit}').to parse.as tuple_type(void, bool, func(bool, void))
    end

    example do
      expect('{unit, true, λx:Bool.unit}').to parse.as tuple(unit, tru, abs(:x, bool, unit))
    end

    example do
      expect('{unit, true, λx:Bool.unit}.3').to parse.as proj(tuple(unit, tru, abs(:x, bool, unit)), 3)
    end

    example do
      expect('{unit, true, λx:Bool.unit}.0').to parse.as proj(tuple(unit, tru, abs(:x, bool, unit)), 0)
    end

    example do
      expect('{unit, true, λx:Bool.unit}.4').to parse.as proj(tuple(unit, tru, abs(:x, bool, unit)), 4)
    end

    example do
      expect('(λx:Bool.x).1').to parse.as proj(abs(:x, bool, var(:x)), 1)
    end
  end

  describe 'records' do
    example do
      expect('{x:Bool, y:Bool → Bool, z:Unit}').to parse.as record_type(x: bool, y: func(bool, bool), z: void)
    end

    example do
      expect('{x=false, y=λx:Bool.true, z=unit}').to parse.as record([:x, fls], [:y, abs(:x, bool, tru)], [:z, unit])
    end

    example do
      expect('{x=false, y=λx:Bool.true, x=unit}').to parse.as record([:x, fls], [:y, abs(:x, bool, tru)], [:x, unit])
    end

    example do
      expect('{x=false, y=λx:Bool.true, z=unit}.y').to parse.as proj(record([:x, fls], [:y, abs(:x, bool, tru)], [:z, unit]), :y)
    end

    example do
      expect('{x=false, y=λx:Bool.true, z=unit}.w').to parse.as proj(record([:x, fls], [:y, abs(:x, bool, tru)], [:z, unit]), :w)
    end

    example do
      expect('true.x').to parse.as proj(tru, :x)
    end
  end

  describe 'sums' do
    example do
      expect('Bool + Unit').to parse.as sum(bool, void)
    end

    example do
      expect('inl true as Bool + Unit').to parse.as inl(tru, sum(bool, void))
    end

    example do
      expect('inr unit as Bool + Unit').to parse.as inr(unit, sum(bool, void))
    end

    example do
      expect('inl unit as Bool + Unit').to parse.as inl(unit, sum(bool, void))
    end

    example do
      expect('inl true as Bool').to parse.as inl(tru, bool)
    end

    example do
      expect('case inl true as Bool + Unit of inl x ⇒ x | inr y ⇒ y; false').to parse.as cas(inl(tru, sum(bool, void)), :x, var(:x), :y, seq(var(:y), fls))
    end

    example do
      expect('case inl true as Bool + Unit of inl x ⇒ x | inr y ⇒ λz:Bool.y').to parse.as cas(inl(tru, sum(bool, void)), :x, var(:x), :y, abs(:z, bool, var(:y)))
    end

    example do
      expect('case true of inl x ⇒ x | inr y ⇒ y; false').to parse.as cas(tru, :x, var(:x), :y, seq(var(:y), fls))
    end
  end

  describe 'variants' do
    example do
      expect('<none: Unit, some: Bool>').to parse.as variant(none: void, some: bool)
    end

    example do
      expect('<some=true> as <none: Unit, some: Bool>').to parse.as tag(:some, tru, variant(none: void, some: bool))
    end

    example do
      expect('<some=unit> as <none: Unit, some: Bool>').to parse.as tag(:some, unit, variant(none: void, some: bool))
    end

    example do
      expect('<many=false> as <none: Unit, some: Bool>').to parse.as tag(:many, fls, variant(none: void, some: bool))
    end

    example do
      expect('<some=true> as Unit × Bool').to parse.as tag(:some, tru, prod(void, bool))
    end

    example do
      expect('case <some=true> as <none:Unit, some:Bool> of <none=x> ⇒ false | <some=y> ⇒ y').to parse.as casv(tag(:some, tru, variant(none: void, some: bool)), [[:none, :x, fls], [:some, :y, var(:y)]])
    end

    example do
      expect('case true of <none=x> ⇒ false | <some=y> ⇒ y').to parse.as casv(tru, [[:none, :x, fls], [:some, :y, var(:y)]])
    end

    example do
      expect('case <some=true> as <none:Unit, some:Bool> of <none=x> ⇒ false | <some=y> ⇒ y | <many=z> ⇒ true').to parse.as casv(tag(:some, tru, variant(none: void, some: bool)), [[:none, :x, fls], [:some, :y, var(:y)], [:many, :z, tru]])
    end

    example do
      expect('case <some=true> as <none:Unit, some:Bool> of <some=y> ⇒ y').to parse.as casv(tag(:some, tru, variant(none: void, some: bool)), [[:some, :y, var(:y)]])
    end

    example do
      expect('case <some=true> as <none:Unit, some:Bool> of <none=x> ⇒ false | <some=y> ⇒ y | <some=z> ⇒ z').to parse.as casv(tag(:some, tru, variant(none: void, some: bool)), [[:none, :x, fls], [:some, :y, var(:y)], [:some, :z, var(:z)]])
    end

    example do
      expect('case <some=true> as <none:Unit, some:Bool> of <none=x> ⇒ x | <some=y> ⇒ y').to parse.as casv(tag(:some, tru, variant(none: void, some: bool)), [[:none, :x, var(:x)], [:some, :y, var(:y)]])
    end
  end

  describe 'fix' do
    example do
      expect('fix λie:Nat → Bool.λx:Nat.if iszero x then true else if iszero (pred x) then false else ie (pred (pred x))').to parse.as fix(abs(:ie, func(nat, bool), abs(:x, nat, cond(is_zero(var(:x)), tru, cond(is_zero(pred(var(:x))), fls, app(var(:ie), pred(pred(var(:x)))))))))
    end

    example do
      expect('fix λieio:{iseven:Nat → Bool, isodd:Nat → Bool}.{iseven=λx:Nat.if iszero x then true else ieio.isodd (pred x), isodd=λx:Nat.if iszero x then false else ieio.iseven (pred x)}').to parse.as fix(abs(:ieio, record_type(iseven: func(nat, bool), isodd: func(nat, bool)), record([:iseven, abs(:x, nat, cond(is_zero(var(:x)), tru, app(proj(var(:ieio), :isodd), pred(var(:x)))))], [:isodd, abs(:x, nat, cond(is_zero(var(:x)), fls, app(proj(var(:ieio), :iseven), pred(var(:x)))))])))
    end

    example do
      expect('fix iszero (succ 0)').to parse.as fix(is_zero(succ(zero)))
    end

    example do
      expect('fix λx:Nat.iszero x').to parse.as fix(abs(:x, nat, is_zero(var(:x))))
    end
  end

  describe 'letrec' do
    example do
      expect('letrec iseven:Nat → Bool = λx:Nat.if iszero x then true else if iszero (pred x) then false else iseven (pred (pred x)) in iseven (succ (succ (succ 0)))').to parse.as letrec(:iseven, func(nat, bool), abs(:x, nat, cond(is_zero(var(:x)), tru, cond(is_zero(pred(var(:x))), fls, app(var(:iseven), pred(pred(var(:x))))))), app(var(:iseven), succ(succ(succ(zero)))))
    end
  end

  describe 'lists' do
    example do
      expect('List Nat').to parse.as list(nat)
    end
  end
end
