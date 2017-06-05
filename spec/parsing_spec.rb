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
  end
end
