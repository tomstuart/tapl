module Term
  False = Object.new
  If = Struct.new(:condition, :consequent, :alternative)
  IsZero = Struct.new(:term)
  Pred = Struct.new(:term)
  Succ = Struct.new(:term)
  True = Object.new
  Variable = Struct.new(:name)
  Zero = Object.new
end
