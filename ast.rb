module Calc
  # A module defining an Abstract Syntax Tree for Calc
  module AST
    # A class that represents the top level program of an Abstract Syntax Tree.
    class Program
      attr_accessor :definitions, :expression

      # Creates and initializes a new instance of Calc::AST::Program
      def initialize()
        self.definitions = []
      end

      # Evaluates the Calc::AST::Program
      def evaluate()
        self.expression.evaluate
      end

      # Returns the validitiy of the Calc::AST::Definition.
      def valid?
        return false if self.expression.nil?
        self.definitions.all?{|d| d.valid? } && self.expression.valid?
      end

      # Returns the value for an identifier within a Calc::AST::Definition
      def value_for(variable)
        d = self.definitions.select{|d| d.identifier == variable }.last
        if d
          return d.value
        end
        Calc::runtime_exception("Variable #{variable} not defined.")
      end

      # Returns a string representation of the Calc::AST::Program.
      def to_s
        self.definitions.join("\n") + "\n" + self.expression.to_s
      end
    end

    # A class that represents a Calc definition.
    class Definition
      attr_accessor :identifier, :value

      # Returns the validitiy of the Calc::AST::Definition.
      def valid?
        self.identifier && self.value
      end

      # Returns a string representation of the Calc::AST::Definition.
      def to_s
        "(let #{self.identifier} #{self.value})"
      end
    end

    # A class that represents a Calc expression.
    class Expression
      attr_accessor :program, :parent, :operator, :left_operand, :right_operand

      # Creates and initializes a new instance of Calc::AST::Expression given a Calc::AST::Program
      def initialize(program)
        @program = program
      end

      # Evaluates the Calc::AST::Expression based on the Ruby implementation of the operator.
      def evaluate
        case self.operator
        when "*"
          return self.left_operand.value * self.right_operand.value
        when "/"
          return self.left_operand.value / self.right_operand.value
        when "+"
          return self.left_operand.value + self.right_operand.value
        when "-"
          return self.left_operand.value - self.right_operand.value
          """ADDED what to do when '^' is read"""
        when "^"
          return self.left_operand.value ** self.right_operand.value
        else
          Calc::runtime_exception("Operation not found.")
        end
      end

      # Returns the validitiy of the Calc::AST::Expression.
      def valid?
        self.operator && self.left_operand && self.right_operand
      end

      # Returns a string representation of the Calc::AST::Expression.
      """ADDED right and left to_s"""
      def to_s
        "(#{self.operator} #{self.left_operand.to_s} #{self.right_operand.to_s})"
      end
    end

    # A class that represents an operand in a Calc expression.
    class Operand
      attr_accessor :literal, :identifier, :expression

      # Creates and initializes a new instance of Calc::AST::Operand given a Calc::AST::Expression
      def initialize(expression)
        @expression = expression
      end

      # Returns the value of the Calc::AST::Operand.
      # Can be a sub-expression, literal value, or identifier.
      def value
        return self.expression.program.value_for(self.identifier) unless self.identifier.nil?
        return self.literal unless self.literal.nil?
        return self.expression.evaluate unless self.expression.nil?
        Calc::runtime_exception("Operand not defined")
      end

      # Returns a string representation of the Calc::AST::Operand.
      def to_s
        self.literal || self.identifier || self.expression.to_s
      end
    end

  end
end
