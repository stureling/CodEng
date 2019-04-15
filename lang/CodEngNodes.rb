#!/usr/bin/env ruby
require_relative 'CodEngRuntime.rb'
require_relative 'CodEngClassDef.rb'

#Parsern genererar noder
#I noderna kommer alla andra klasser att kallas och 

class CEBlockNode
    def initialize
        
    end
end

class CEIfStatmentNode
    def initialize
        
    end
end

class CEForLoopNode
    def initialize
        
    end
end

class CEWhileLoopNode
    def initialize
        
    end
end

class CERelationOpNode
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

class CEArithmeticOpNode
    def initialize(expr1, op, expr2)
        @expr1 = expr1
        @op = op
        @expr2 = expr2
    end

    def assess
        case @op
        when :plus then return (@expr1.add(@expr2))
        when :minus then return (@expr1.subtract(@expr2))
        when :mult then return (@expr1.multiply(@expr2))
        when :div then return (@expr1.divide(@expr2))
        when :exponent then return (@expr1.pow(@expr2))
        end
    end
end

class CEAndNode
    def initialize
        
    end
end

class CEOrNode
    def initialize
        
    end
end

class CENotNode
    def initialize
        
    end
end

class CEVarAssignNode
    def initialize
        
    end
end

class CEOutputNode
    def initialize
        
    end
end

class CEInputNode
    def initialize
        
    end
end

class CEPrintNode
    def initialize
        
    end
end
