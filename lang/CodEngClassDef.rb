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

class CEArray < CEObject
  attr_reader :array
  def initialize()
    @array = []
  end

  def append(expr)
    @array.append(expr)
    return self
  end

  def add(expr, pos)
    @array.insert(pos, expr)
    return self
  end

  def remove(pos)
    @array.delete_at(pos)
    return self
  end

  def get(pos)
    return @array[pos]
  end

  def size()
    return CEInteger.new(@array.size)
  end

  def assess(scope)
    return self
  end
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
  attr_reader :name, :block, :args, :defaults, :scope
  def initialize(name, block, scope, args=[])
    @name, @block, @scope = name, block, scope
    @args = []
    @defaults = 0
    args.each do |arg|
      if arg.is_a?(CEVarAssignNode)
        @scope.set_var(arg.var, arg.expr.assess(@scope)) 
        @defaults = @defaults + 1
        arg = arg.var
      end
      @args.push(arg)
    end
  end

  def assess(scope)
    if @block.size == 0
      return CENil
    end
    @block.each do |b| 
      if b.is_a?(CEReturn)
        return b.assess(scope)
      else
        b.assess(scope)
      end
    end
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
