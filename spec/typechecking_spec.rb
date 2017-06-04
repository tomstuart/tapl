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
end
