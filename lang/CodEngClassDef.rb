#!/usr/bin/env ruby

=begin
TODO PRIORITY LIST

1. Function def
2. loops and function call
3. everything else
=end

class CEObject
    def name
    end
end

class CENil
end

class CEVariable < CEObject
  attr_reader :value, :name
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

class CEString < CEObject
  def initialize(string)
    @string = string
  end

  def assess(scope)
    return @string
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
