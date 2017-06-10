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
    parse_ascription
  end

  def parse_ascription
    term = parse_sequence

    if can_read? %r{as}
      read %r{as}
      type = parse_type
      builder.build_ascription(term, type)
    else
      term
    end
  end

  def parse_sequence
    term = parse_applications

    if can_read? %r{;}
      read %r{;}
      builder.build_sequence(term, parse_sequence)
    else
      term
    end
  end

  def parse_applications
    term = parse_projection

    until can_read? %r{\)|\}|>|then|else|;|as|in|,|\.|of|\||\z} do
      term = builder.build_application(term, parse_projection)
    end

    term
  end

  def parse_projection
    term = parse_term_in_projection

    if can_read? %r{\.}
      read %r{\.}
      index =
        if can_read? %r{[a-z_]+}
          read_name
        else
          read %r{\d+}
        end
      builder.build_projection(term, index)
    else
      term
    end
  end

  def parse_term_in_projection
    if can_read? %r{\(}
      parse_brackets
    elsif can_read? %r{\{}
      parse_pair_or_tuple_or_record
    elsif can_read? %r{<}
      parse_tagging
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
    elsif can_read? %r{unit}
      parse_unit
    elsif can_read? %r{let}
      parse_let
    elsif can_read? %r{inl|inr}
      parse_sum
    elsif can_read? %r{case}
      parse_case
    elsif can_read? %r{fix}
      parse_fix
    elsif can_read? %r{[a-z_]+}
      parse_variable
    elsif can_read? %r{[λ^\\]}
      parse_abstraction
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

  def parse_unit
    read %r{unit}

    builder.build_unit
  end

  def parse_variable
    name = read_name

    builder.build_variable(name)
  end

  def parse_abstraction
    read %r{[λ^\\]}
    parameter_name = read_name
    read %r{:}
    parameter_type = parse_type
    read %r{\.}
    body = parse_term

    builder.build_abstraction(parameter_name, parameter_type, body)
  end

  def parse_let
    read %r{let}
    definition_name = read_name
    read %r{=}
    definition_term = parse_term
    read %r{in}
    body = parse_term

    builder.build_let(definition_name, definition_term, body)
  end

  def parse_pair_or_tuple_or_record
    read %r{\{}
    if can_read? %r{[a-z_]+\s*=}
      fields = []
      loop do
        label = read_name
        read %r{=}
        term = parse_term
        fields << builder.build_record_field(label, term)
        break unless can_read? %r{,}
        read %r{,}
      end
      read %r{\}}

      builder.build_record(fields)
    else
      terms = []
      loop do
        terms << parse_term
        break unless can_read? %r{,}
        read %r{,}
      end
      read %r{\}}

      if terms.length == 2
        builder.build_pair(*terms)
      else
        builder.build_tuple(terms)
      end
    end
  end

  def parse_sum
    tag = read %r{inl|inr}
    term = parse_sequence
    read %r{as}
    type = parse_type

    case tag
    when 'inl'
      builder.build_in_left(term, type)
    when 'inr'
      builder.build_in_right(term, type)
    end
  end

  def parse_case
    read %r{case}
    term = parse_term
    read %r{of}
    if can_read? %r{inl}
      read %r{inl}
      left_name = read_name
      read %r{⇒}
      left_term = parse_term
      read %r{\|}
      read %r{inr}
      right_name = read_name
      read %r{⇒}
      right_term = parse_term
      builder.build_case(term, left_name, left_term, right_name, right_term)
    else
      cases = []
      loop do
        read %r{<}
        label = read_name
        read %r{=}
        name = read_name
        read %r{>}
        read %r{⇒}
        case_term = parse_term
        cases << builder.build_variant_case_case(label, name, case_term)
        break unless can_read? %r{\|}
        read %r{\|}
      end

      builder.build_variant_case(term, cases)
    end
  end

  def parse_tagging
    read %r{<}
    label = read_name
    read %r{=}
    term = parse_term
    read %r{>}
    read %r{as}
    type = parse_type

    builder.build_tagging(label, term, type)
  end

  def parse_fix
    read %{fix}
    builder.build_fix(parse_term)
  end

  def parse_type
    parse_type_functions
  end

  def parse_type_functions
    type = parse_type_sum

    if can_read? %r{→}
      read %r{→}
      builder.build_type_function(type, parse_type_functions)
    else
      type
    end
  end

  def parse_type_sum
    type = parse_type_product

    if can_read? %r{\+}
      read %r{\+}
      other_type = parse_type_product
      builder.build_type_sum(type, other_type)
    else
      type
    end
  end

  def parse_type_product
    type = parse_type_in_product

    if can_read? %r{×}
      read %r{×}
      other_type = parse_type_in_product
      builder.build_type_product(type, other_type)
    else
      type
    end
  end

  def parse_type_in_product
    if can_read? %r{\(}
      parse_type_brackets
    elsif can_read? %r{\{}
      parse_type_tuple_or_record
    elsif can_read? %r{<}
      parse_type_variant
    elsif can_read? %r{Bool}
      parse_type_boolean
    elsif can_read? %r{Nat}
      parse_type_natural_number
    elsif can_read? %r{Unit}
      parse_type_unit
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

  def parse_type_unit
    read %r{Unit}

    builder.build_type_unit
  end

  def parse_type_tuple_or_record
    read %r{\{}
    if can_read? %r{[a-z_]+\s*:}
      fields = []
      loop do
        label = read_name
        read %r{:}
        type = parse_type
        fields << builder.build_type_record_field(label, type)
        break unless can_read? %r{,}
        read %r{,}
      end
      read %r{\}}

      builder.build_type_record(fields)
    else
      types = []
      loop do
        types << parse_type
        break unless can_read? %r{,}
        read %r{,}
      end
      read %r{\}}

      builder.build_type_tuple(types)
    end
  end

  def parse_type_variant
    fields = []
    read %r{<}
    loop do
      label = read_name
      read %r{:}
      type = parse_type
      fields << builder.build_type_variant_field(label, type)
      break unless can_read? %r{,}
      read %r{,}
    end
    read %r{>}

    builder.build_type_variant(fields)
  end

  def read_name
    read %r{[a-z_]+}
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
