#!/usr/bin/env ruby

=begin
TODO PRIORITY LIST

1. function call
2. everything else
=end

class CEObject
    def name
    end
end

class CENil
end

class CEVariable < CEObject
  attr_reader :name
  def initialize(name)
    @name = name.to_sym
  end

  def assess(scope)
    scope.get_var(@name).assess(scope)
  end
end

class CENumber < CEObject
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
  attr_reader :name, :block, :args
  def initialize(name, block, args=[])
    @name, @block, @args = name, block, args
  end

  def assess(scope)
    @block.each { |b| b.assess(scope) }
  end
end

class CEString < CEObject
  def initialize(string)
    @string = string
  end

  def assess(scope)
    return self
  end
end

class CEBool < CEObject
  def initialize(object)
    @boolvalue = assert_boolvalue(object)
  end

  def assess(scope)
    return self
  end
  
  def value
    return @boolvalue
  end

end
