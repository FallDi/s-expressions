class Element

  @key = nil
  @data = nil

  def initialize(key, data)
	@key = key
	@data = data
  end

  def get_attributes
	if @data.kind_of?(Array)
	  puts @data.first.get_key
	  return @data.first.get_key == "@"
	end
	nil
  end

  def get_key
	@key
  end

  def is_empty?
	return true if (@key == nil)
	false
  end

  def convert_to_s_expression(depth = 0)
	if (depth == 0 && self.is_empty?)
	  puts '()'
	  return
	end

	str_pad = " " * depth
	if @data.kind_of?(Array)
	  print str_pad + "("
	  print @key.to_s

	  if (@data.length != 0)
		puts " => "
		@data.each { |x|
		  x.convert_to_s_expression(depth+2)
		}
	  end
	  puts str_pad + ")"
	else
	  puts str_pad + "(" +(@key.to_s + " => ") + @data.to_s + ")"
	end

  end

  # debug methods
  def inspect
	"[" + @key.to_s + " => " + @data.inspect + "]"
  end

end