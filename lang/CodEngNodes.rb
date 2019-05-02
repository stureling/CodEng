#!/usr/bin/env ruby
require_relative 'CodEngRuntime.rb'
require_relative 'CodEngClassDef.rb'

#Parsern genererar noder
#I noderna kommer alla andra klasser att kallas och 

class CEBlockNode
  def initialize()
      
  end
end

class CEIfStatementNode
  def initialize(logic_comp, stmt)
    @logic_comp, @stmt = logic_comp, stmt
  end

  def assess(scope)
    new_scope = CEScope.new("if", scope)
    if @logic_comp.value then
      @stmt.assess(new_scope)
    end
  end
end

class CEIfElseStatementNode
  def initialize(logic_comp, stmt, else_stmt)
    @logic_comp, @stmt, @else_stmt = logic_comp, stmt, else_stmt
  end

  def assess(scope)
    new_scope = CEScope.new("if", scope)
    if @logic_comp.value then
      @stmt.assess(new_scope)
    else
      @else_stmt.assess(new_scope)
    end
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
    expr = assert_boolvalue(@expr.assess(scope))
    if !expr
      return CEBool.new(true)
    else
      return CEBool.new(false)
    end
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
    expr1, expr2 = assert_boolvalue(@expr1.assess(scope)), assert_boolvalue(@expr2.assess(scope))
    case @op
    when :eqlless then return CEBool.new(expr1.value <= expr2.value)
    when :eqlgreater then return CEBool.new(expr1.value >= expr2.value)
    when :less then return CEBool.new(expr1.value < expr2.value)
    when :greater then return CEBool.new(expr1.value > expr2.value)
    when :equal then return CEBool.new(expr1.value == expr2.value)
    when :notequal then return CEBool.new(expr1.value != expr2.value)
    end
  end
end

class CELogicANDNode
  #Logical AND
  def initialize(expr1, expr2)
      @expr1, @expr2 = expr1, expr2
  end

  def assess(scope)
    expr1, expr2 = assert_boolvalue(@expr1.assess(scope)), assert_boolvalue(@expr2.assess(scope))
    if expr1 and expr2
      return CEBool.new(true)
    else
      return CEBool.new(false)
    end
  end
end

class CELogicORNode
    #Logical OR
  def initialize(expr1, expr2)
    @expr1, @expr2 = expr1, expr2
  end
  
  def assess(scope)
    expr1, expr2 = assert_boolvalue(@expr1.assess(scope)), assert_boolvalue(@expr2.assess(scope))
    if expr1 or expr2
      return CEBool.new(true)
    else
      return CEBool.new(false)
    end
  end
end

class CEVarAssignNode
  def initialize(var, expr)
      @var = var
      @expr = expr
  end

  def assess(scope)
    if scope.contains?(var.name)
      scope = scope.get_scope(var.name)
    end
    scope.add(@var, @expr)
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
