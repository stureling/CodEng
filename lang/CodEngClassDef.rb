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

class Forloop
    def initialize

    end
end

class Whileloop
    def initialize
        
    end
end