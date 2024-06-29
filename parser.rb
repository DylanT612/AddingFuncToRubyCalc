require_relative '../Calc'
require_relative 'token'
require_relative 'ast'

module Calc
  # A class that parses Calc syntax and produces an Abstract Syntax Tree
  class Parser

    # Returns a Calc::AST::Program which is the base of the Calc Abstract Syntax Tree
    def self.parse(tokens)
      definitions = []
      program = AST::Program.new # Create the top level Program
      top_expression = AST::Expression.new(program) # Every Program needs at least one top level Expression
      program.expression = top_expression

      current = nil
      tokens.each do |t|
        case t.type
        when Token::LET
          # If we don't have a current Expression or Definition, create one.
          if current.nil?
            current = AST::Definition.new
          else
            Calc::invalid_syntax(t.value,t.column,"The keyword let cannot be used more than once within a statement.")
          end
        when Token::IDENTIFIER
          case current
          when AST::Expression
            # If we are in the context of an Expression, the Identifier must be an Operand.
            if current.left_operand.nil?
              current.left_operand = AST::Operand.new(current)
              current.left_operand.identifier = t.value
            elsif current.right_operand.nil?
              current.right_operand = AST::Operand.new(current)
              current.right_operand.identifier = t.value
              current = current.parent # If we've seen an operator and both operands, let's go back to our parent.
            else
              Calc::invalid_syntax(t.value,t.column,"An identifier can only be used as an operand within an expression.")
            end
          when AST::Definition
            # If we are in the context of a Definition, it must be the identifier for the Definition.
            if current.identifier.nil?
              current.identifier = t.value
            else
              Calc::invalid_syntax(t.value,t.column,"An identifier can only be used as an identifier within an definition.")
            end
          else
            Calc::invalid_syntax(t.value,t.column,"An identifier can only be used within an expression or definition.")
          end
        when Token::NUMBER
          case current
          when AST::Expression
            # If we are in the context of an Expression, the literal number must be an Operand.
            if current.left_operand.nil?
              current.left_operand = AST::Operand.new(current)
              current.left_operand.literal = t.value
            elsif current.right_operand.nil?
              current.right_operand = AST::Operand.new(current)
              current.right_operand.literal = t.value
              current = current.parent # If we've seen an operator and both operands, let's go back to our parent.
            else
              Calc::invalid_syntax(t.value,t.column,"A number can only be used as an operand within an expression.")
            end
          when AST::Definition
            # If we are in the context of a Definition, it must be the value for the Definition.
            current.value = t.value
            program.definitions << current
            current = nil
          else
            Calc::invalid_syntax(t.value,t.column,"A number can only be used once within a definition.")
          end
        when Token::OPERATOR
          case current
          when nil
            # If we don't have a context, we must be the first operator for the top level Expression.
            current = top_expression
            current.operator = t.value
          when AST::Expression
            # If we're in the context of an expression:
            if current.operator.nil?
              # If we haven't seen the operator yet, assign it.
              current.operator = t.value
            elsif current.left_operand.nil?
              # If we have seen the operator and our left Operand is nil, our left operator must be an Expression.
              current.left_operand = AST::Operand.new(current)
              current.left_operand.expression = AST::Expression.new(program)
              current.left_operand.expression.operator = t.value
              current.left_operand.expression.parent = current # Save our reference so we can come back.
              current = current.left_operand.expression # Nest the Expression
            elsif current.right_operand.nil?
              # If we have seen the operator and our right Operand is nil, our right operator must be an Expression.
              current.right_operand = AST::Operand.new(current)
              current.right_operand.expression = AST::Expression.new(program)
              current.right_operand.expression.operator = t.value
              current.right_operand.expression.parent = current # Save our reference so we can come back.
              current = current.right_operand.expression # Nest the Expression
            else
              Calc::invalid_syntax(t.value,t.column,"An operator can only be used once within an expression.")
            end
          else
            Calc::invalid_syntax(t.value,t.column,"An operator can only be used within an expression.")
          end
        else
          Calc::invalid_syntax(t.type,t.column,"Invalid Token type.")
        end
      end

      program
    end
  end
end
