#!/usr/bin/env 

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
    puts @name, @vars
  end

  def get_var(var_name)
    puts @name, @vars
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
      return @parent.get_scope(var_name)
    else
      return false
    end
  end

  #Function functions
   
  def add_fun(function)
    @functions[function.name] = function
    puts @functions
  end

  def get_fun(fun_name)
    if @functions.has_key?(fun_name)
      return @functions[fun_name]
    elsif @parent != nil
      return @parent.get_fun(fun_name)
    end
      raise "Function '#{fun_name.to_s}' not declared in current scope or parents"
  end

  #Helper functions

  def root
    #@parent == nil ? return self : return @parent.root
    if @parent == nil then
      return self
    else 
      return @parent.root
    end
  end

  def assess
    return self
  end
end
