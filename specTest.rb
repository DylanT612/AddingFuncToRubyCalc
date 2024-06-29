# CalcTest/specTest.rb

# Load necessary files from the calc folder
require_relative '../calc/ast'
require_relative '../calc/token'
require_relative '../calc/parser'
require_relative '../calc/lexer'
require_relative '../calc/evaluator'

# Load minitest framework for Ruby
require 'minitest/autorun'

class CalcSpecificationTest < Minitest::Test
  def test_addition_operator
    source_code = "(+ 10 5)"
    tokens = Calc::Lexer.lex(source_code)
    program = Calc::Parser.parse(tokens)
    result = Calc::Evaluator.evaluate(program)
    assert_equal 15, result
  end

  def test_subtraction_operator
    source_code = "(- 10 5)"
    tokens = Calc::Lexer.lex(source_code)
    program = Calc::Parser.parse(tokens)
    result = Calc::Evaluator.evaluate(program)
    assert_equal 5, result
  end

  def test_multiplication_operator
    source_code = "(* 10 5)"
    tokens = Calc::Lexer.lex(source_code)
    program = Calc::Parser.parse(tokens)
    result = Calc::Evaluator.evaluate(program)
    assert_equal 50, result
  end

  def test_division_operator
    source_code = "(/ 10 5)"
    tokens = Calc::Lexer.lex(source_code)
    program = Calc::Parser.parse(tokens)
    result = Calc::Evaluator.evaluate(program)
    assert_equal 2, result
  end

  def test_power_operator
    source_code = "(^ 2 4)"
    tokens = Calc::Lexer.lex(source_code)
    program = Calc::Parser.parse(tokens)
    result = Calc::Evaluator.evaluate(program)
    assert_equal 16, result
  end
end
