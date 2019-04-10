#!/usr/bin/env ruby

class Reloperators
    def initialize(in1, comp_op, in2 = nil)
        @in1 = in1
        @in2 = in2
        @comp_op = comp_op
    end
    def assess
        if @comp_op == :eqlless
            return (@in1 <= @in2)
        elsif @comp_op == :eqlgreater
            return (@in1 >= @in2)
        elsif @comp_op == :less
            return (@in1 < @in2)
        elsif @comp_op == :greater
            return (@in1 > @in2)
        elsif @comp_op == :equal
            return (@in1 == @in2)
        elsif @comp_op == :not
            return (!@in1)
        elsif @comp_op == :and
            return (@in1 && @in2)
        elsif @comp_op == :or
            return (@in1 || @in2)
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
        if @op == :plus
            return (@expr1 + @expr2)
        elsif @op == '-'
            return (@expr1 - @expr2)
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
end

class Floatnum
    def initialize(num)
	    @value = num.to_f
    end
end

class Charstring
    def initialize(num)
	#TODO
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

