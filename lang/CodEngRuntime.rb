#!/usr/bin/env 

#HELPER FUNCTIONS
def assert_boolvalue(object)

  #verkar inte fungera med switch - case 
=begin
  classtype = object.class
  puts object.value
  puts classtype

  case classtype
  when CEInteger
    if object.value != 0
      return true
    else
      return false
    end
  when CEFloat
    if object.value != 0
      return true
    else
      return false
    end
  when CEBool
    if object.value == true
      return true
    else
      return false
    end
  when TrueClass then return true
  when FalseClass then return false
  end
  raise "Invalid type #{object.class}, expected CEBool, CEFloat, CEInteger, TrueClass or FalseClass"
=end
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
#
# Scope ska skapas vid behov vid t.ex. for-loopar. For-loopen kommer köra assess(scope) på alla sina
# subprograms men den kommer att ha skickat med ett nytt scope till sina subprograms. Ya get it?
class CEScope
  def initialize(name, parent=nil)
    @name, @parent = name, parent
    @vars = {}
  end

  def add(var, expr)
    puts var
    puts expr
    scope = self
    if self.contains?(var.name)
      puts "why you in here"
      scope = get_scope(var.name)
    end
    scope.set_var(var, expr)
  end

  def set_var(var, expr)
    puts "should be here"
    #Only used internally by function add. Sets the var in the current scope.
    @vars[var.name = expr]
  end

  def get_var(var)
    if @vars.has_key?(var_name)
      return @vars[var_name]
    elsif @parent != nil
      return @parent.get(var_name)
    end
      raise "Variable '#{var_name.to_s}' not declared in current scope or parents"
  end

  def get_scope(var)
    if @vars.has_key?(var.name)
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
    
  def root
    #@parent == nil ? return self : return @parent.root
  end

  def assess
    #Probably a print function?
  end

  def for_tests
    return self
  end
end
