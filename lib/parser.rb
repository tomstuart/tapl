class Parser
  def initialize(builder)
    self.builder = builder
  end

  def parse_complete_term(string)
    self.string = string

    term = parse_term
    read %r{\z}

    term
  end

  def parse_complete_type(string)
    self.string = string

    type = parse_type
    read %r{\z}

    type
  end

  private

  attr_accessor :builder
  attr_reader :string

  def string=(string)
    @string = string.strip
  end

  def parse_term
    if can_read? %r{true|false}
      parse_boolean
    else
      complain
    end
  end

  def parse_boolean
    value = read %r{true|false}

    builder.build_boolean(value == 'true')
  end

  def parse_type
    if can_read? %r{Bool}
      parse_type_boolean
    elsif can_read? %r{Nat}
      parse_type_natural_number
    else
      complain
    end
  end

  def parse_type_boolean
    read %r{Bool}

    builder.build_type_boolean
  end

  def parse_type_natural_number
    read %r{Nat}

    builder.build_type_natural_number
  end

  def can_read?(pattern)
    !try_match(pattern).nil?
  end

  def read(pattern)
    match = try_match(pattern) || complain(pattern)
    self.string = match.post_match
    match.to_s
  end

  def try_match(pattern)
    /\A#{pattern}/.match(string)
  end

  def complain(expected = nil)
    complaint = "unexpected #{string.slice(0)}"
    complaint << ", expected #{expected.inspect}" if expected

    raise complaint
  end
end
