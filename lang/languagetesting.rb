require_relative 'CodEngNodes.rb'
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

    def test_a
    end
end
