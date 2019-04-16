#!/usr/bin/env ruby
require_relative 'CodEngRuntime.rb'
require_relative 'CodEngClassDef.rb'

#Parsern genererar noder
#I noderna kommer alla andra klasser att kallas och 

class CEBlockNode
  def initialize
      
  end
end

class CEIfStatmentNode
  def initialize
      
  end
end

class CEForLoopNode
  def initialize
      
  end
end

class CEWhileLoopNode
  def initialize
      
  end
end

class CENotNode
  def initialize(expr)
      #Logic NOT
      @expr = expr
  end

  def assess(scope)
    !@expr.assess(scope).value
  end
end

class CEArithmeticOpNode
  #This node handles all basic math
  def initialize(expr1, op, expr2)
    @expr1, @expr2 = expr1, expr2
    @op = op
  end

  def assess(scope)
    expr1, expr2 = @expr1.assess(scope), @expr2.assess(scope)
    if expr1.is_a?(CENumber) and expr2.is_a?(CENumber)
      case @op
      when :plus then new_value = expr1.value + expr2.value
      when :minus then new_value = expr1.value - expr2.value
      when :mult then new_value = expr1.value * expr2.value
      when :div then new_value = expr1.value / expr2.value
      when :exponent then new_value = expr1.value ** expr2.value
      end
      if new_value.class == Integer then return CEInteger.new(new_value)
      elsif new_value.class == Float then return CEFloat.new(new_value)
      end
    else
      raise "#{object} is of wrong type, should be CEInteger or CEFloat"
    end
  end
end

class CERelationOpNode
  def initialize(expr1, op, expr2)
      @expr1, @expr2 = expr1, expr2
      @op = op
  end

  def assess(scope)
      case @op
      when :eqlless then return (@expr1.assess(scope) <= @expr2.assess(scope))
      when :eqlgreater then return (@expr1.assess(scope) >= @expr2.assess(scope))
      when :less then return (@expr1.assess(scope) < @expr2.assess(scope))
      when :greater then return (@expr1.assess(scope) > @expr2.assess(scope))
      when :equal then return (@expr1.assess(scope) == @expr2.assess(scope))
      when :notequal then return (@expr1.assess(scope) != @expr2.assess(scope))
      end
  end
end

class CELogicANDNode
  #Logical AND
  def initialize(expr1, expr2)
      @expr1, @expr2 = expr1, expr2
  end

  def assess(scope)
      @expr1.assess(scope) && @expr2.assess(scope)
  end
end

class CELogicORNode
    #Logical OR
  def initialize(expr1, expr2)
    @expr1, @expr2 = expr1, expr2
  end
  def assess(scope)
    if @expr1.assess(scope).value || @expr2.assess(scope).value
      return CEBool.new(:true)
    else
      return CEBool.new(:false)
    end
  end
end

class CEVarAssignNode
  def initialize
      
  end
end

class CEOutputNode
  def initialize
      
  end
end

class CEInputNode
  def initialize
      
  end
end

class CEPrintNode
  def initialize
      
  end
end
