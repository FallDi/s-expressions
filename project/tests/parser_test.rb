require "test/unit"
require "../src/parser"

class ParserTest < Test::Unit::TestCase

	def test_parse
		parser = Parser.new()

		assert_equal(true, parser.parse('()').is_empty?)
		assert_equal(Element.new('f', []).inspect, parser.parse('(f)').inspect)
	end

end