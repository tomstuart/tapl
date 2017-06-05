module Term
  False = Object.new
  If = Struct.new(:condition, :consequent, :alternative)
  IsZero = Struct.new(:term)
  Pred = Struct.new(:term)
  Succ = Struct.new(:term)
  True = Object.new
  Zero = Object.new
end
