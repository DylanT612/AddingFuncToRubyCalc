module Calc
  # A class that represents meaningful sets of characters in a Calc program.
  class Token
    # Token type to signal a Calc::AST::Definition
    LET = 0
    # Token type to signal an identifier
    IDENTIFIER = 1
    # Token type to signal a literal number
    NUMBER = 2
    # Token type to signal an oeprator
    OPERATOR = 3

    attr_accessor :type,:value,:column

    # Creates a new instance of Calc::Token
    def initialize(type,value,column)
      @type = type
      @value = value
      @column = column
    end
  end
end
