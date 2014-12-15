require_relative 'element'
require_relative 'validator'

class Parser

	REPLACEMENT = "__INTERNAL_STRING_REPLACEMENT__"

	# return original string with replaced string atoms, and string atoms
	def extract_string_atoms (string)
    string_literals = []
		string_literal_pattern = /"[^"].*?"/
    # extract strings
    string.gsub(string_literal_pattern) {|x|
	    string_literals << x
    }
    # replace strings
    string = string.gsub(string_literal_pattern, REPLACEMENT)

    [string, string_literals]
	end


	# add spaces around parentheses
	def tokenize_string (string)
		string = string.gsub("(", " ( ")
		string = string.gsub(")", " ) ")
		token_array = string.split(" ")

		token_array
	end

	def restore_string_literals (token_array, string_literals)
    token_array.map { |x|
      if(x == REPLACEMENT)
        string_literals.shift
      else
        x
      end
    }
	end

	def convert_tokens( token_array )
		converted_tokens = []
		token_array.each do |t|
			converted_tokens << "(" and next if( t == "(" )
			converted_tokens << ")" and next if( t == ")" )
			converted_tokens << t.to_i and next if( Validator.is_integer_literal?(t) )
			converted_tokens << (t == 'true') and next if( Validator.is_boolean_literal?(t) )
			converted_tokens << t.to_sym and next if( Validator.is_symbol?(t) )
			converted_tokens << t.to_s and next if( Validator.is_string_literal?(t) )
			# If we haven't recognized the token by now we need to raise
			# an exception as there are no more rules left to check against!
			raise Exception, "Unrecognized token: #{t}!"
		end

		converted_tokens
	end

	def re_structure( token_array, offset = 0 )
		struct = []
		while( offset < token_array.length )
			if(token_array[offset] == "(")
				# Multiple assignment from the array that re_structure() returns
				offset, tmp_array = re_structure(token_array, offset + 1)
				struct << tmp_array
			elsif(token_array[offset] == ")")
				break
			else
				struct << token_array[offset]
			end
			offset += 1
		end

		[offset, struct]
	end


	def transform_to_elements (elements_array)
		key = elements_array.first
		values = elements_array[1..-1]

		elements = []
		if (values && values.count)
			values.each {|x|
				if x.kind_of?(Array)
					elements << transform_to_elements(x)
				else
					elements = x
				end
			}
		end

		element = Element.new(key, elements)

		element
	end

	def parse (string)
    string, string_literals = self.extract_string_atoms(string)
    token_array = tokenize_string( string )
	  token_array = restore_string_literals( token_array, string_literals )
    token_array = convert_tokens( token_array )
    s_expression = re_structure(token_array)[1]
    s_expression = s_expression.first

    s_expression = transform_to_elements(s_expression)
    s_expression
	end

end