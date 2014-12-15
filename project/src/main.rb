require_relative "parser.rb"


parser = Parser.new()

example1 = parser.parse('(fruits
  (fruit (@ (fresh true) (weight 5))
    (name "apple")
    (color "green")
  )
(fruit (@ (fresh true) (weight 5))
    (name "apple")
    (color "green")
  )
)')

example1.convert_to_s_expression
puts example1.inspect

example2 = p.parse('(f)')
example2.convert_to_s_expression
puts example2.inspect