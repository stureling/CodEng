#!/usr/bin/env ruby
class Scope
    def initialize(id, parent=nil)
        @id, @parent = id, parent
        @vars = {}
    end

    def add(var)
        @vars[var.name] = var
    end

    def get(var_name)
      if @vars.has_key?(var_name)
          return @vars[var_name]
      elsif @parent != nil
          return @parent.get(var_sym)
      end
      raise "Variable '#{var_sym.to_s}' not found in current scope"
    end
    
    def root
      @parent == nil ? return self : return @parent.root
    end

    def assess
      #Probably a print function?
    end
end
