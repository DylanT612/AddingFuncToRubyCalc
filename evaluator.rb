require_relative 'ast'

module Calc
  # A simple class that evaluates a Calc::AST::Program
  class Evaluator
    # Evaluates a Calc::AST::Program
    def self.evaluate(program)
      program.evaluate
    end
  end
end
