#!/usr/bin/env ruby
require_relative 'CodEngClassDef.rb'

#Parsern genererar noder
#I noderna kommer alla andra klasser att kallas och 

class CEProgramNode
  # Top layer node, contains a list of other nodes.
  def initialize(statements)
    @statements = statements
  end

  def assess(scope)
    latest_statement = CENil
    @statements.each do |statement|
      latest_statement = statement.assess(scope)
    end
    return latest_statement
  end
end

class CEFunctionDefNode
  # Defines functions
  attr_reader :name, :block, :args
  def initialize(name, block, args=[])
    @name, @block = name, block
    if args.is_a?(Array)
      @args = args
    else
      @args = [args]
    end
  end

  def assess(scope)
    scope.add_fun(CEFunction.new(@name, @block, CEScope.new('function', scope), @args))
  end
end

class CEFunctionCallNode
  # Translates arguments and then calls the function
  def initialize(name, args=[])
    @name, @args = name.name, args
  end

  def assess(scope)
    fun = scope.get_fun(@name)
    if @args.size > fun.args.size or @args.size < fun.args.size - fun.defaults
      raise "Invalid number of arguments, expected #{fun.args.size} got #{@args.size}"
    elsif @args.size != 0
      puts "Calling args: ", @args.inspect
      puts "Defined args: ", fun.args.inspect
      @args.zip(fun.args).each do |arg|
        puts "Zipped arg: ", arg.inspect
        fun.scope.set_var(arg[1], arg[0].assess(scope))
      end
    end
    fun.assess(fun.scope)
  end
end

class CEReturn
  def initialize(expr)
    @expr = expr
  end

  def assess(scope)
    return @expr.assess(scope)
  end
end

class CEIfStatementNode
  # Assesses the block if the condition is true
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
  # Assesses the block if the condition is true, otherwise the else_block is assessed.
  def initialize(condition, block, else_block)
    @condition, @block, @else_block = condition, block, else_block
  end

  def assess(scope)
    new_scope = CEScope.new("if", scope)
    if assert_boolvalue(@condition.assess(scope)) then
      @block.each { |b| b.assess(new_scope) }      
    else
      @else_block.each { |b| b.assess(new_scope) }  
    end
  end
end

class CEWhileLoopNode
  # Assesses a block continously while the condition is met
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
  # Assesses an expressions boolean value and reverses it
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
  # This node handles all basic math
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

    elsif expr1.is_a?(CEString) and expr2.is_a?(CEString)
      case @op
      when :plus then return CEString.new(expr1.value + expr2.value)
      end
      raise "Invalid operator #{@op} for object type CEString"

    elsif expr1.is_a?(CEString) or expr2.is_a?(CEString) and  expr1.is_a?(CEInteger) or expr2.is_a?(CEInteger) 

      case @op
      when :mult then return CEString.new(expr1.value * expr2.value)
      end
      raise "Invalid operator #{@op} for object types CEString and CEInteger"

    else
      raise "#{expr1} or #{expr2} is of wrong type, should be CEInteger, CEFloat or CEString in arithmetic operations"
    end
  end
end

class CERelationOpNode
  # This node handles comparisons between data types
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
  # Assesses 2 expressions boolean values and returns true if both are true, otherwise false.
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
  # Assesses 2 expressions boolean values and returns true if at least one is true, otherwise false.
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
  # Assigns varibles to the scope
  attr_reader :expr, :var
  def initialize(var, expr)
      @var = var
      @expr = expr
  end

  def assess(scope)
    if not @var.is_a?(CEVariable)
      @var = @var.assess(scope)
    end
    scope.add_var(@var, @expr.assess(scope))
    return @expr.assess(scope)
  end
end

class CEVarDeclerationNode
  # Assigns varibles to the scope
  def initialize(var)
      @var = var
  end

  def assess(scope)
    scope.set_var(@var, CENil.new)
    return @var
  end
end

class CEPrintNode
  # Prints printable values, if the object is not a printable a description of the object  is printed instead
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
        puts expr.inspect
      else
        print expr.inspect
      end
    end
  end
end

#SCOPE
class CEScope
  # Contains, sets, and retrives variables and functions
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
    # Returns the scope containing the variable, raises and error if variable is not found.
    if @vars.has_key?(var_name)
      return self
    elsif @parent != nil
      return @parent.get_scope(var_name)
    else
      raise "Variable '#{var_name.to_s}' not declared in current scope or parents"
    end
  end

  def contains?(var_name)
    # Returns true if the variable is declared in the current scope or parents.
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
    # Return the root scope
    if @parent == nil then
      return self
    else 
      return @parent.root
    end
  end
end

#HELPER FUNCTIONS
def assert_boolvalue(object)
  # Asserts the boolean value of an object, if the type can't be translated to a boolean an error is thrown.
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


