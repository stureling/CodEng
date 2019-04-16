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
        return expr
    end
end

class CENumber < CEObject
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
          if object.is_a?(CEFloat)
              self.assess.to_f / object.assess.to_f
          else
              return self.assess / object.assess
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

class CEBool < CEObject
    def initialize(bool_sym)
        if bool_sym == :true
            @boolvalue = true
        elsif bool_sym == :false
            @boolvalue = false
        end
    end
    def assess
        return @boolvalue
    end
end

#x = CEBool.new(:true)
#puts x.assess