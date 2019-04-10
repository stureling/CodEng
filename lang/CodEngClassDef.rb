#!/usr/bin/env ruby

class Reloperators
    def initialize(in1, comp_op, in2)
        @in1 = in1
        @in2 = in2
        @comp_op = comp_op
    end
    def compare
        if @comp_op == "<="
            return (@in1 <= @in2)
        elsif @comp_op == ">="
            return (@in1 >= @in2)
        elsif @comp_op == "=="
            return (@in1 == @in2)
        elsif @comp_op == "!=" || @comp_op == "not"
            return (@in1 != @in2)
        elsif @comp_op == "&&" || @comp_op == "and"
            return (@in1 && @in2)
        elsif @comp_op == "||" || @comp_op == "or"
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
