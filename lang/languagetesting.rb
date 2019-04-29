require_relative 'CodEngNodes.rb'
require_relative 'CodEngParse.rb'
require 'test/unit'

class TestLanguage < Test::Unit::TestCase
    def test_assert_boolvalue_func
        x = CEFloat.new(0.1)
        assert_equal(assert_boolvalue(x), true)
        x = CEFloat.new(0.0)
        assert_equal(assert_boolvalue(x), false)
        x = CEInteger.new(1)
        assert_equal(assert_boolvalue(x), true)
        x = CEInteger.new(0)
        assert_equal(assert_boolvalue(x), false)
    end
end

    #why no names in CEFLOATS QQ
    #def test_assert_arithmeticnode
    #    scope = CEScope.new("fortests")
    #    scope.add(CEFloat.new(3.4), "test_x")
    #    scope.add(CEFloat.new(4.1), "test_y")
    #    assert_equal(CEArithmeticOpNode.new(x.value, :plus, y.value).assess(scope), 7.5)
    #end