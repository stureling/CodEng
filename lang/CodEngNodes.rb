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

class CENotNode
    def initialize(expr)
        #Logic NOT
        @expr = expr
    end

    def assess
        !@expr.assess
    end
end

class CEExponentNode
    def initialize(expr1, expr2)
        #Expontiation
        @expr1, @expr2 = expr1, expr2        
    end

    def assess
        return (@expr1.power(@expr2))
    end
end

class CEMultDivOpNode
    def initialize(expr1, op, expr2)
        @expr1, @expr2 = expr1, expr2
        @op = op
    end

    def assess
        case @op
        when :mult then return (@expr1.multiply(@expr2))
        when :div then return (@expr1.divide(@expr2))
        end
    end
end

class CEAddSubOpNode
    def initialize(expr1, op, expr2)
        @expr1, @expr2 = expr1, expr2
        @op = op
    end

    def assess
        case @op
        when :plus then return (@expr1.add(@expr2))
        when :minus then return (@expr1.subtract(@expr2))
        end
    end
end

class CERelationOpNode
    def initialize(expr1, op, expr2)
        @expr1, @expr2 = expr1, expr2
        @op = op
    end

    def assess
        case @op
        when :eqlless then return (@expr1.assess <= @expr2.assess)
        when :eqlgreater then return (@expr1.assess >= @expr2.assess)
        when :less then return (@expr1.assess < @expr2.assess)
        when :greater then return (@expr1.assess > @expr2.assess)
        end
    end
end

class CERelEqNoteqNode
    def initialize(expr1, op, expr2)
        @expr1, @expr2 = expr1, expr2
        @op = op
    end
    def assess
        case @op
        when :equal then return (@expr1.assess == @expr2.assess)
        when :notequal then return (@expr1.assess != @expr2.assess)
        end
    end
end

class CELogicANDNode
    #Logical AND
    def initialize(expr1, expr2)
        @expr1, @expr2 = expr1, expr2
    end

    def assess
        @expr1.assess && @expr2.assess
    end
end

class CELogicORNode
    #Logical OR
    def initialize(expr1, expr2)
        @expr1, @expr2 = expr1, expr2
    end

    def assess
        @expr1.assess || @expr2.assess
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
