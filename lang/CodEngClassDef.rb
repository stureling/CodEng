#!/usr/bin/env ruby

=begin
TODO PRIORITY LIST

1. Scopes and function def
2. loops and function call
3. everything else
=end

class CEOperator

end

class CEObject
end

class CENil < CEObject
end

class CEVariable < CEObject
    def initialize(name, expr)
        @name = name
        @expr = expr
    end

    def assess
    end

    def value
        return expr
    end
end

class CENumber < CEObject
  #Inherit from CEInt and CEFloat to see if it is a float or int
  #So we know if the return is int or float for multi, div and exp?
  def add(object)
      if object.is_a?(CENumber)
          return self.assess + object.assess
      else
        raise "#{object.class} #{object.name} is of wrong type, should be integer or float"
      end
  end

  def subtract(object)
      if object.is_a?(CENumber)
          return self.assess - object.assess
      else
        raise "#{object.class} #{object.name} is of wrong type, should be integer or float"
      end
  end

  def multiply(object)
      if object.is_a?(CENumber)
        return self.assess.to_f * object.assess.to_f
      else
        raise "#{object.class} #{object.name} is of wrong type, should be integer or float"
      end
  end
  def divide(object)
      if object.is_a?(CENumber)
        return self.assess.to_f / object.assess.to_f
      else
        raise "#{object.class} #{object.name} is of wrong type, should be integer or float"
      end
  end

  def power(object)
      if object.is_a?(CENumber)
        return self.assess.to_f ** object.assess.to_f
      else
        raise "#{object.class} #{object.name} is of wrong type, should be integer or float"
      end
  end
end

class CEInteger < CENumber
    def initialize(num)
	      @value = num.to_i
    end

    def assess
        return @value
    end
end

class CEFloat < CENumber
    def initialize(num)
	    @value = num.to_f
    end
    def assess
        return @value
    end
end

class CEString < CEObject
    def initialize(string)
        @string = string
    end
    def assess
        return @string
    end
end
