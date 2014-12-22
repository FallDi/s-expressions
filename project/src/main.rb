require_relative 'parser.rb'
require_relative 'schema.rb'
require_relative 'search.rb'


parser = Parser.new
example1 = parser.parse('(fruits
  (fruit (@ (fresh true) (weight 5))
    (name "apple")
    (color "green")
  )
(fruit (@ (fresh false) (weight 5))
    (name "orange")
    (color "orange")
  )
)')


puts example1.inspect
example1.search('/fruits/fruit/name["orange"]')
example1.convert_to_s_expression
puts '-' * 10


example1 = parser.parse('(fruits (@ (fresh true)) "hello")')
schema1 = parser.parse('(element (& (name fruits) (type string)))')


schema = Schema.new(schema1)
schema.validate(example1)
