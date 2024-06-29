# examples/power.rb
require_relative '../Calc'
require_relative '../calc/ast'
require_relative '../calc/token'
require_relative '../calc/parser'
require_relative '../calc/lexer'
require_relative '../calc/evaluator'

# Create an instance of the lexer
lexer = Calc::Lexer

# Source code containing the expression (^ 2 16)
source_code = "(^ 2 16)"

# Lex the source code to produce tokens
tokens = lexer.lex(source_code)

# Parse tokens into an Abstract Syntax Tree (AST)
program = Calc::Parser.parse(tokens)

# Print the definitions and operations to verify
puts "Definitions:", program.definitions
puts "Operations:", program.expression

# Evaluate the Calc program
result = Calc::Evaluator.evaluate(program)
puts "Result:", result
