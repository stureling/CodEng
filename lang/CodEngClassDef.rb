#!/usr/bin/env ruby

class CEObject
  # Base class for all objects
end

class CENil
  # Base class for no object
  def assess(_)
    return self
  end
end

class CEVariable < CEObject
  # Variable name holder, used by CEVarAssignNode to assign an expression to a variable.
  attr_reader :name
  def initialize(name)
    @name = name.to_sym
  end

  def assess(scope)
    scope.get_var(@name).assess(scope)
  end
end

class CEPrintable < CEObject
  # Base class for object with printable values
end

class CENumber < CEPrintable
  # Base class for numbers
end

class CEInteger < CENumber
  attr_reader :value
  def initialize(num)
    @value = num.to_i
  end

  def assess(scope)
    return self
  end
end

class CEFloat < CENumber
  attr_reader :value
    def initialize(num)
	    @value = num.to_f
    end
    def assess(scope)
        return self
    end
end

class CEFunction < CEObject
  # Contains a code block and arguments. 
  # Created by CEFunctionDef and assessed by CEFunctionCall
  attr_reader :name, :block, :args
  def initialize(name, block, args=[])
    @name, @block, @args = name, block, args
  end

  def assess(scope)
    if @block.size == 0
      return CENil
    end
    @block.each { |b| b.assess(scope) }
  end
end

class CEString < CEPrintable
  attr_reader :value
  def initialize(string)
    @value = string
  end

  def assess(scope)
    return self
  end
end

class CEBool < CEPrintable
  attr_reader :value
  def initialize(object)
    @value = assert_boolvalue(object)
  end

  def assess(scope)
    return self
  end
end
