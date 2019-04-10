#!/usr/bin/env ruby

class Scope
    def initialize()
        
    end

    def assess
    
    end
end

class Reloperators
    def initialize(expr1, op, expr2 = nil)
        @expr1 = expr1
        @expr2 = expr2
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

class Wholenum
    def initialize(num)
	      @value = num.to_i
    end

    def assess
        return @value
    end
end

class Floatnum
    def initialize(num)
	    @value = num.to_f
    end
    def assess
        return @value
    end
end

class Charstring
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

class Hashtable
    def initialize(num)
        #TODO
    end
end

class Forloop
    def initialize
	#TODO
    end
end

class Whileloop
    def initialize
	#TODO
    end
end

