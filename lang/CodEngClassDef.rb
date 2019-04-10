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
        when :eqlless return (@expr1 <= @expr2)
        when :eqlgreater return (@expr1 >= @expr2)
        when :less return (@expr1 < @expr2)
        when :greater return (@expr1 > @expr2)
        when :equal return (@expr1 == @expr2)
        when :not return (!@expr1)
        when :and return (@expr1 && @expr2)
        when :or return (@expr1 || @expr2)
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
        when :plus return (@expr1 + @expr2)
        when :minus return (@expr1 - @expr2)
        when :mult return (@expr1 * @expr2)
        when :div return (@expr1 / @expr2)
        when :exponent return (@expr1 ** @expr2)
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

