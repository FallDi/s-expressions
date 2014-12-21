require "test/unit"
require_relative "../src/parser"

class ParserTest < Test::Unit::TestCase

  def test_parse

	parser = Parser.new

	assert_equal(true, parser.parse('()').is_empty?)
	assert_equal(Element.new('f', []).inspect, parser.parse('(f)').inspect)
	assert_equal(Element.new('f',
		Element.new('key', :value)).inspect,
		parser.parse('(f (key value))').inspect
	)
	assert_equal(
		Element.new('f', [Element.new('key', :value), Element.new('key2', :value2)]).inspect,
		parser.parse('(f (key value) (key2 value2))').inspect
	)
  end

end