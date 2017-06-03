Context = Struct.new(:mappings) do
  def initialize(mappings = {})
    super
  end

  def lookup(name)
    mappings[name]
  end

  def extend(name, type)
    self.class.new(mappings.merge(name => type))
  end
end
