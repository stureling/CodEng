require_relative 'CodEngClassDef.rb'
require 'test/unit'

class TestLanguage < Test::Unit::TestCase
    def test_relops
        a = Reloperators.new(3, :less, 5)
        assert_equal(a.assess, true)
        a = Reloperators.new(10, :less, 5)
        assert_equal(a.assess, false)
        a = Reloperators.new(3, :greater, 5)
        assert_equal(a.assess, false)
        a = Reloperators.new(10, :greater, 5)
        assert_equal(a.assess, true)
        a = Reloperators.new(3, :eqlless, 5)
        assert_equal(a.assess, true)
        a = Reloperators.new(10, :eqlless, 5)
        assert_equal(a.assess, false)
        a = Reloperators.new(3, :eqlgreater, 5)
        assert_equal(a.assess, false)
        a = Reloperators.new(3, :equal, 5)
        assert_equal(a.assess, false)
        a = Reloperators.new(false, :not) 
        assert_equal(a.assess, true)
        a = Reloperators.new(true, :and, true)
        assert_equal(a.assess, true)
        a = Reloperators.new(true, :and, false)
        assert_equal(a.assess, false)
        a = Reloperators.new(false, :and, false)
        assert_equal(a.assess, false)
        a = Reloperators.new(false, :or, false)
        assert_equal(a.assess, false)
        a = Reloperators.new(false, :or, false)
        assert_equal(a.assess, false)
        a = Reloperators.new(true, :or, false)
        assert_equal(a.assess, true)
        a = Reloperators.new(true, :or, true)
        assert_equal(a.assess, true)
    end
end