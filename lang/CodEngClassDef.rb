#!/usr/bin/env ruby

=begin
TODO PRIORITY LIST

1. Scopes and function def
2. loops and function call
3. everything else
=end
class Scope
    def initialize(id, parent=nil)
        @id, @parent = id, parent
        @vars = {}
    end

    def add(var)
        @vars[var.name.to_sym] = var
    end

    def get(var_sym)
      if @vars.has_key?(var_sym)
          return @vars[var_sym]
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

class RelOperators
    def initialize(expr1, op, expr2 = nil)
        @expr1, @expr2 = expr1, expr2
        @op = op
    end
    def assess
        case @op
        when :eqlless then return (@expr1 <= @expr2)
        when :eqlgreater then return (@expr1 >= @expr2)
        when :less then return (@expr1 < @expr2)
        when :greater then return (@expr1 > @expr2)
        when :equal then return (@expr1 == @expr2)
        when :not then return (!@expr1)
        when :and then return (@expr1 && @expr2)
        when :or then return (@expr1 || @expr2)
        end
    end
end

class Operators
    def initialize(expr1, op, expr2)
        @expr1 = expr1
        @op = op
        @expr2 = expr2
    end

    def assess
        case @op
        when :plus then return (@expr1 + @expr2)
        when :minus then return (@expr1 - @expr2)
        when :mult then return (@expr1 * @expr2)
        when :div then return (@expr1 / @expr2)
        when :exponent then return (@expr1 ** @expr2)
        end
    end
end

class VarAssign
    def initialize(name, expr)
        @name = name
        @expr = expr
    end

    def assess
        #assign the variable
        #TODO
    end
end

class WholeNum
    def initialize(num)
	      @value = num.to_i
    end

    def assess
        return @value
    end
end

class FloatNum
    def initialize(num)
	    @value = num.to_f
    end
    def assess
        return @value
    end
end

class CharString
    def initialize(string)
        @string = string
    end
    def assess
        return @string
    end
end

class List
    def initialize(num)
	#TODO
    end
end

class HashTable
    def initialize(num)
        #TODO
    end
end

class ForLoop
    def initialize
	#TODO
    end
end

class WhileLoop
    def initialize
	#TODO
    end
end

class Output
    def initialize
	#TODO
    end
end

class Input
    def initialize
	#TODO
    end
end
