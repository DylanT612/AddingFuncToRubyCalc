require_relative 'calc/ast'
require_relative 'calc/token'
require_relative 'calc/parser'
require_relative 'calc/lexer'
require_relative 'calc/evaluator'

# The Calc Programming Language
module Calc
  # Generates an invalid syntax error message and exits the interpreter
  def self.invalid_syntax(s,c,reason)
    $stderr.puts "Invalid syntax near #{s} (column: #{c})"
    $stderr.puts reason
    exit 1
  end

  # Generates a runtime error message and exits the interpreter
  def self.runtime_exception(e)
    $stderr.puts "[RUNTIME ERROR]: #{e}"
    exit 1
  end
end
