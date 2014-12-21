class Element

  TYPE_SEQUENCE = :sequence
  TYPE_STRING = :string
  TYPE_BOOLEAN = :boolean
  TYPE_INTEGER = :integer
  TYPE_ELEMENT = :element

  @key = nil
  @data = nil

  def initialize(key, data)
	@key = key
	@data = data
  end

  def get_attributes
	if @data.is_sequence?
	  puts @data.first.get_key
	  return @data.first.get_key == '@'
	end
	nil
  end

  def get_types
	result = nil
	if @data.kind_of?(Array)
	  result = @data.first.get_value
	elsif @data.get_key == :&
	  result = @data.get_value
	end

	if result.kind_of?(Array)
	  result
	else
	  [result]
	end
  end

  def get_type
	if @data.kind_of?(Array)
	  TYPE_SEQUENCE
	elsif @data.kind_of?(Element)
	  TYPE_ELEMENT
	elsif @data.kind_of?(String)
	  TYPE_STRING
	elsif @data.kind_of?(Integer)
	  TYPE_INTEGER
	elsif @data == 'true' || @data == 'false'
	  TYPE_BOOLEAN
	else
	  raise 'Unknown data type: ' + @data.class.name
	end
  end

  def get_key
	@key
  end

  def get_value
	result = @data
	if result.kind_of?(Array)
	  result.find_all { |x|
		x.get_key != :&
	  }
	elsif result.kind_of?(Element)
	  return nil if (result.get_key == :&)
	  result
	else
	  result
	end
  end

  def is_empty?
	return true if (@key == nil)
	false
  end

  def is_atom?
	return true if (@data.kind_of?(Element))
	false
  end

  def is_sequence?
	return true if (@data.kind_of?(Array))
	false
  end

  def convert_to_s_expression(depth = 0)
	if depth == 0 && self.is_empty?
	  puts '()'
	  return
	end

	str_pad = ' ' * depth
	if @data.kind_of?(Array)
	  print str_pad + '('
	  print @key.to_s

	  if @data.length != 0
		puts ' => '
		@data.each { |x|
		  x.convert_to_s_expression(depth+2)
		}
	  end
	  puts str_pad + ')'
	else
	  puts str_pad + '(' +(@key.to_s + ' => ') + @data.to_s + ')'
	end

  end


  # debug methods
  def inspect
	'{' + @key.to_s + ' => ' + @data.inspect + '}'
  end

end