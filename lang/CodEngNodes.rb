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

  def assess
    !@expr.assess.value
  end
end

class CEExponentNode
  def initialize(expr1, expr2)
      #Expontiation
      @expr1, @expr2 = expr1, expr2        
  end

  def assess
      return self.power(@expr1, @expr2)
  end
  def power(expr1, expr2)
    expr1, expr2 = @expr1.assess, @expr2.assess
    if expr1.is_a?(CENumber) and expr2.is_a?(CENumber)
      new_value = expr1.value ** expr2.value
      if new_value.class == Integer then return CEInteger.new(new_value)
      elsif new_value.class == Float then return CEFloat.new(new_value)
      end
    else
      raise "#{object} is of wrong type, should be CEInteger or CEFloat"
    end
  end
end

class CEMultDivOpNode
  def initialize(expr1, op, expr2)
      @expr1, @expr2 = expr1, expr2
      @op = op
  end

  def assess
      case @op
      when :mult then return self.multiply(@expr1, @expr2)
      when :div then return self.divide(@expr1, @expr2)
      end
  end

  def multiply(expr1, expr2)
    expr1, expr2 = @expr1.assess, @expr2.assess
    if expr1.is_a?(CENumber) and expr2.is_a?(CENumber)
      new_value = expr1.value * expr2.value
      if new_value.class == Integer then return CEInteger.new(new_value)
      elsif new_value.class == Float then return CEFloat.new(new_value)
      end
    else
      raise "#{object} is of wrong type, should be CEInteger or CEFloat"
    end
  end

  def divide(expr1, expr2)
    expr1, expr2 = @expr1.assess, @expr2.assess
    if expr1.is_a?(CENumber) and expr2.is_a?(CENumber)
      new_value = expr1.value / expr2.value
      if new_value.class == Integer then return CEInteger.new(new_value)
      elsif new_value.class == Float then return CEFloat.new(new_value)
      end
    else
      raise "#{object} is of wrong type, should be CEInteger or CEFloat"
    end
  end
end

class CEAddSubOpNode
  def initialize(expr1, op, expr2)
    @expr1, @expr2 = expr1, expr2
    @op = op
  end

  def assess
    case @op
    when :plus then self.add(@expr1, @expr2)
    when :minus then self.subtract(@expr1, @expr2)
    end
  end

  def add(expr1, expr2)
    expr1, expr2 = @expr1.assess, @expr2.assess
    if expr1.is_a?(CENumber) and expr2.is_a?(CENumber)
      new_value = expr1.value + expr2.value
      if new_value.class == Integer then return CEInteger.new(new_value)
      elsif new_value.class == Float then return CEFloat.new(new_value)
      end
    else
      raise "#{object} is of wrong type, should be CEInteger or CEFloat"
    end
  end

  def subtract(expr1, expr2)
    expr1, expr2 = @expr1.assess, @expr2.assess
    if expr1.is_a?(CENumber) and expr2.is_a?(CENumber)
      new_value = expr1.value + expr2.value
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

  def assess
      case @op
      when :eqlless then return (@expr1.assess <= @expr2.assess)
      when :eqlgreater then return (@expr1.assess >= @expr2.assess)
      when :less then return (@expr1.assess < @expr2.assess)
      when :greater then return (@expr1.assess > @expr2.assess)
      end
  end
end

class CERelEqNoteqNode
  def initialize(expr1, op, expr2)
      @expr1, @expr2 = expr1, expr2
      @op = op
  end
  def assess
      case @op
      when :equal then return (@expr1.assess == @expr2.assess)
      when :notequal then return (@expr1.assess != @expr2.assess)
      end
  end
end

class CELogicANDNode
  #Logical AND
  def initialize(expr1, expr2)
      @expr1, @expr2 = expr1, expr2
  end

  def assess
      @expr1.assess && @expr2.assess
  end
end

class CELogicORNode
    #Logical OR
  def initialize(expr1, expr2)
    @expr1, @expr2 = expr1, expr2
  end
  def assess
    if @expr1.assess.value || @expr2.assess.value
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
