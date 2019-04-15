#!/usr/bin/env ruby

=begin
TODO PRIORITY LIST

1. Scopes and function def
2. loops and function call
3. everything else
=end

class Variable
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
