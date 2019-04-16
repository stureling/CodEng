#!/usr/bin/env ruby

=begin
TODO PRIORITY LIST

1. Scopes and function def
2. loops and function call
3. everything else
=end

class CEObject
    def name
    end
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
    return expr.assess
  end
end

class CENumber < CEObject
  def add(object)
    if object.is_a?(CENumber)
      new_value = self.value + object.value
      if new_value.class == Integer then return CEInteger.new(new_value)
      elsif new_value.class == Float then return CEFloat.new(new_value)
      end
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
      return self.assess * object.assess
    else
       raise "#{object.class} #{object.name} is of wrong type, should be integer or float"
    end
  end

  def divide(object)
    if object.is_a?(CENumber)
      type = object.class
      if type == Float then return CEFloat.new(self.value.to_f / object.value)
      elsif type == Integer then return CEInteger.new(self.value / object.value)
      end
    else
      raise "#{object} is of wrong type, should be integer or float"
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
  attr_reader :value
  def initialize(num)
    @value = num.to_i
  end

  def assess
    return self
  end
end

class CEFloat < CENumber
  attr_reader :value
    def initialize(num)
	    @value = num.to_f
    end
    def assess
        return self
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
