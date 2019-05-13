#!/usr/bin/env ruby
require_relative 'CodEngClassDef.rb'

#Parsern genererar noder
#I noderna kommer alla andra klasser att kallas och 

class CEProgramNode
  def initialize(statements)
    @statements = statements
  end

  def assess(scope)
    temp = 1
    @statements.each do |statement|
      temp = statement.assess(scope)
    end
    return temp
  end
end

class CEFunctionDefNode
  attr_reader :name, :block, :args
  def initialize(name, block, args=[])
    @name, @block, @args = name, block, args
  end

  def assess(scope)
    scope.add_fun(CEFunction.new(@name, @block, @args))
  end
end

class CEFunctionCallNode
  def initialize(name, args=[])
    @name, @args = name.name, args
  end

  def assess(scope)
    new_scope = CEScope.new("Function #{@name.to_s}", scope)
    fun = scope.get_fun(@name)
    if @args.size != 0
      @args.zip(fun.args).each do |arg|
        new_scope.set_var(arg[1], arg[0])
      end
    end
    fun.assess(new_scope)
  end
end

class CEIfStatementNode
  def initialize(condition, block)
    @condition, @block = condition, block
  end

  def assess(scope)
    new_scope = CEScope.new("if", scope)
    if assert_boolvalue(@condition.assess(scope)) then
      @block.each { |b| b.assess(new_scope) }      
    end
  end
end

class CEIfElseStatementNode
  def initialize(condition, block, else_block)
    @condition, @block, @else_block = condition, block, else_block
  end

  def assess(scope)
    new_scope = CEScope.new("if", scope)
    if assert_boolvalue(@condition.assess(scope)) then
      @block.each { |b| b.assess(new_scope) }      
    else
      @else_block.assess(new_scope) { |b| b.assess(new_scope) }  
    end
  end
end

class CEWhileLoopNode
  def initialize(condition, block)
    @condition, @block = condition, block
  end

  def assess(scope)
    new_scope = CEScope.new("while", scope)
    while assert_boolvalue(@condition.assess(scope)) do
      @block.each { |b| b.assess(new_scope) }
    end
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
      raise "#{expr1} or #{expr2} is of wrong type, should be CEInteger or CEFloat"
    end
  end
end

class CERelationOpNode
  def initialize(expr1, op, expr2)
    @expr1, @expr2 = expr1, expr2
    @op = op
  end

  def assess(scope)
    expr1, expr2 = @expr1.assess(scope), @expr2.assess(scope)
    case @op
    when :less_or_eql then return CEBool.new(expr1.value <= expr2.value)
    when :greater_or_eql then return CEBool.new(expr1.value >= expr2.value)
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
    if scope.contains?(@var.name)
      scope = scope.get_scope(@var.name)
    end
    scope.add_var(@var, @expr.assess(scope))
    return @expr.assess(scope)
  end
end

class CEPrintNode
  def initialize(args=[], newline=false)
    @args, @newline = args, newline
  end

  def assess(scope)
    @args.each do |arg|
      expr = arg.assess(scope)
      if expr.is_a?(CEPrintable)
        expr = expr.value
      end
      if @newline
        puts expr
      else
        print expr
      end
    end
  end
end

#SCOPE
class CEScope
  def initialize(name, parent=nil)
    @name, @parent = name, parent
    @vars = {}
    @functions = {}
  end

  #Var functions

  def add_var(var, expr)
    scope = self
    if self.contains?(var.name)
      scope = get_scope(var.name)
    end
    scope.set_var(var, expr)
  end

  def set_var(var, expr)
    @vars[var.name] = expr
  end

  def get_var(var_name)
    if @vars.has_key?(var_name)
      return @vars[var_name]
    elsif @parent != nil
      return @parent.get_var(var_name)
    end
      raise "Variable '#{var_name.to_s}' not declared in current scope or parents"
  end

  def get_scope(var_name)
    if @vars.has_key?(var_name)
      return self
    elsif @parent != nil
      return @parent.get_scope(var_name)
    else
      raise "Variable '#{var_name.to_s}' not declared in current scope or parents"
    end
  end

  def contains?(var_name)
    if @vars.has_key?(var_name)
      return true
    elsif @parent != nil
      return @parent.contains?(var_name)
    else
      return false
    end
  end

  #Function functions
   
  def add_fun(function)
    @functions[function.name] = function
  end

  def get_fun(fun_name)
    if @functions.has_key?(fun_name)
      return @functions[fun_name]
    elsif @parent != nil
      return @parent.get_fun(fun_name)
    end
      raise "Function '#{fun_name.to_s}' not declared in current scope or parents"
  end

  #others

  def root
    #@parent == nil ? return self : return @parent.root
    if @parent == nil then
      return self
    else 
      return @parent.root
    end
  end
end

#HELPER FUNCTIONS
def assert_boolvalue(object)
  classtype = object.class

  if classtype == CEInteger then
    if object.value != 0
      return true
    else
      return false
    end
  elsif classtype == CEFloat
    if object.value != 0
      return true
    else
      return false
    end
  elsif classtype == CEBool
    if object.value == true
      return true
    else
      return false
    end
  elsif classtype == TrueClass then return true
  elsif classtype == FalseClass then return false
  end
  raise "Invalid type #{object.class}, expected CEBool, 
  CEFloat, CEInteger, TrueClass or FalseClass"
end


