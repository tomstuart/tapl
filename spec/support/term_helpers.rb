require 'builder'

module TermHelpers
  def fls
    Builder.new.build_boolean(false)
  end

  def tru
    Builder.new.build_boolean(true)
  end
end
