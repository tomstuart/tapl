module Term
  Abstraction = Struct.new(:parameter_name, :parameter_type, :body)
  Application = Struct.new(:left, :right)
  False = Object.new
  If = Struct.new(:condition, :consequent, :alternative)
  IsZero = Struct.new(:term)
  Pred = Struct.new(:term)
  Sequence = Struct.new(:first, :second)
  Succ = Struct.new(:term)
  True = Object.new
  Unit = Object.new
  Variable = Struct.new(:name)
  Zero = Object.new

  def self.free_names(term)
    case term
    when Abstraction
      free_names(term.body) - [term.parameter_name]
    when Application
      free_names(term.left) + free_names(term.right)
    when If
      free_names(term.condition) + free_names(term.consequent) + free_names(term.alternative)
    when Sequence
      free_names(term.first) + free_names(term.second)
    when True, False
      []
    when Unit
      []
    when Variable
      term.name
    else
      raise "can’t find free names for #{term}"
    end
  end

  def self.all_names
    0.step.lazy.map { |n| n.times.inject('a') { |s| s.succ } }
  end

  def self.fresh_name(term)
    names = free_names(term)
    all_names.detect { |name| !names.include?(name) }
  end

  def self.desugar(term)
    case term
    when Sequence
      Application.new(Abstraction.new(fresh_name(term.second), Type::Unit, term.second), term.first)
    else
      raise "can’t desugar #{term}"
    end
  end
end
