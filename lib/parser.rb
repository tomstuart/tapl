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
    if can_read? %r{\(}
      parse_brackets
    elsif can_read? %r{true|false}
      parse_boolean
    elsif can_read? %r{0}
      parse_zero
    elsif can_read? %r{pred}
      parse_pred
    elsif can_read? %r{succ}
      parse_succ
    elsif can_read? %r{iszero}
      parse_is_zero
    elsif can_read? %r{if}
      parse_if
    elsif can_read? %r{[a-z]+}
      parse_variable
    else
      complain
    end
  end

  def parse_brackets
    read %r{\(}
    term = parse_term
    read %r{\)}

    term
  end

  def parse_boolean
    value = read %r{true|false}

    builder.build_boolean(value == 'true')
  end

  def parse_zero
    read %r{0}

    builder.build_zero
  end

  def parse_pred
    read %r{pred}
    term = parse_term

    builder.build_pred(term)
  end

  def parse_succ
    read %r{succ}
    term = parse_term

    builder.build_succ(term)
  end

  def parse_is_zero
    read %r{iszero}
    term = parse_term

    builder.build_is_zero(term)
  end

  def parse_if
    read %r{if}
    condition = parse_term
    read %r{then}
    consequent = parse_term
    read %r{else}
    alternative = parse_term

    builder.build_if(condition, consequent, alternative)
  end

  def parse_variable
    name = read_name

    builder.build_variable(name)
  end

  def parse_type
    parse_type_functions
  end

  def parse_type_functions
    type = parse_type_in_function

    if can_read? %r{→}
      read %r{→}
      builder.build_type_function(type, parse_type_functions)
    else
      type
    end
  end

  def parse_type_in_function
    if can_read? %r{\(}
      parse_type_brackets
    elsif can_read? %r{Bool}
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

  def parse_type_brackets
    read %r{\(}
    type = parse_type
    read %r{\)}

    type
  end

  def read_name
    read %r{[a-z]+}
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
