module Term
  WILDCARD = '_'

  Abstraction = Struct.new(:parameter_name, :parameter_type, :body)
  Application = Struct.new(:left, :right)
  Ascription = Struct.new(:term, :type)
  Case = Struct.new(:term, :left_name, :left_term, :right_name, :right_term)
  False = Object.new
  Fix = Struct.new(:term)
  If = Struct.new(:condition, :consequent, :alternative)
  InLeft = Struct.new(:term, :type)
  InRight = Struct.new(:term, :type)
  IsZero = Struct.new(:term)
  Let = Struct.new(:definition_name, :definition_term, :body)
  LetRec = Struct.new(:definition_name, :definition_type, :definition_term, :body)
  Pair = Struct.new(:first, :second)
  Pred = Struct.new(:term)
  Projection = Struct.new(:term, :index)
  Record = Struct.new(:fields)
  Record::Field = Struct.new(:label, :term)
  Sequence = Struct.new(:first, :second)
  Succ = Struct.new(:term)
  Tagging = Struct.new(:label, :term, :type)
  True = Object.new
  Tuple = Struct.new(:terms)
  Unit = Object.new
  Variable = Struct.new(:name)
  VariantCase = Struct.new(:term, :cases)
  VariantCase::Case = Struct.new(:label, :name, :term)
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
    when Abstraction
      raise "can’t desugar #{term}" unless term.parameter_name == WILDCARD
      Abstraction.new(fresh_name(term.body), term.parameter_type, term.body)
    when Ascription
      name = fresh_name(term.term)
      Application.new(Abstraction.new(name, term.type, Variable.new(name)), term.term)
    when Sequence
      Application.new(Abstraction.new(fresh_name(term.second), Type::Unit, term.second), term.first)
    else
      raise "can’t desugar #{term}"
    end
  end
end
