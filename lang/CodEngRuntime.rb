#!/usr/bin/env ruby

#HELPER FUNCTIONS
def assert_boolvalue(object)
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

  def add(var)
    @vars[var.name] = var
  end

  def get(var_name)
    if @vars.has_key?(var_name)
      return @vars[var_name]
    elsif @parent != nil
      return @parent.get(var_name)
    end
      raise "Variable '#{var_name.to_s}' not declared in current scope or parents"
    end
    
    def root
      #@parent == nil ? return self : return @parent.root
    end

    def assess
      #Probably a print function?
    end
end
