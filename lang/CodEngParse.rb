#!/usr/bin/env ruby

require_relative 'rdparse.rb'
require_relative 'CodEngClassDef.rb'

class CodEng

  def initialize
    @CodEngParser = Parser.new( "CodEng") do
      token(/\s+/)
      token(/-?\d+/) { |t| t.to_i }
      token(/\*\*|to the power of/) { :exponent }
      token(/\+|plus/) { :plus }
      token(/-|minus/) { :minus }
      token(/\*|times/) { :mult }
      token(/\/|over/) { :div }
      token(/true/) { :true }
      token(/false/) { :false }
      token(/&&|and/) { :and }
      token(/\|\||or/) { :or }
      token(/!|not /) { :not }
      token(/==|equal to/) { :equal }
      token(/>|greater than/) { :greater }
      token(/>=|equal or greater than/) { :eqlgreater }
      token(/<|less than/) { :less }
      token(/<=|equal or less than/) { :eqllesser }
      token(/=|is/) { |t| t }
      token(/[a-zA-Z_]+/) { |t| t }
      token(/./) { |t| t }


      start :block do
        #match('start', :statements, 'stop') { |_, m, _| m }
        match(:statements) { |m| m}
        #match(start, :statements, :block, stop) { |_, a, b, _| a, b }
      end
      
      rule :statements do
        match(:statements, :statment) { |m| m }
        match(:statment) { |m| m }
      end

      rule :statment do
        match(:matched) { |m| m }
        match(:unmatched) { |m| m }
      end

      rule :unmatched do
        #match('if', :logic_expr, 'then' :statment) { |_, l, _, s| if l then s end}
        #match('if', :logic_expr, 'then' :matched 'else' :statment) { |_, l, _, m, _, s| if l then m else s end}
      end

      rule :matched do
        #match('if', :logic_expr, 'then' :matched 'else' :matched) { |_, l, _, m, _, m| if l then m else m end}
        match(:for_loop) { |m| m }
        match(:while_loop) { |m| m}
        match(:valid) { |m| m }
      end
=begin
      rule :for_loop do
        match('for', :var, 'in', :var, 'do', :block) { |_, v, _, w, _ b| for v in w do b end}
        match(:expr) { |m| m }
      end

      rule :while_loop do
        match('while', :logic_expr 'do' :block) { |_, l, _, b| while l do b end}
        match(:expr) { |m| m }
      end
=end
      rule :valid do
        match(:assign) { |m| m }
        match(:expr) { |m| m }
      end

      rule :assign do
        match(:var, '=', :expr) { |var, _, expr| VarAssign.new(var, expr) }
        #match(:prefix, :var, 'is', :expr) { |_, var, _, expr| @vars[var] = expr } #
      end

      rule :prefix do
      end

      rule :expr do
        match(:logic_expr)
      end

      rule :arithmetic_expr do
	      match(:arithmetic_expr, :plus, :term) { |a, b, c| Operators.new(a, b, c) }
        match('add', :arithmetic_expr, 'to', :term) { |_, a, _, b| Operators.new(a, '+', b) }
        match(:arithmetic_expr, :minus, :term) { |a, _, b| Operators.new(a, '-', b) }
        match('subtract', :arithmetic_expr, 'from', :term) { |_, a, _, b| Operators.new(a, '-', b) }
        match(:term) { |m| m }
      end

      rule :term do
        match(:term, :mult, :factor) { |a, _, b| a * b }
        match('multiply', :term, 'by', :factor) { |_, a, _, b| a * b }
        match(:term, :div, :factor) { |a, _, b| a / b }
        match('divide', :term, 'by', :factor) { |_, a, _, b| a / b }
        match(:factor) { |m| m }
      end

      rule :factor do
        match(:exp, :exponent, :factor) { |a, _, b| a**b }
        match(:exp) { |m| m }
      end

      rule :exp do
        match('(', :arithmetic_expr, ')') { |_, m, _| m }
        match(:var) { |m| m }
      end

      rule :var do
        match(/[a-zA-z]{1}\w*/) { |var| @vars.key?(var) ? @vars[var] : var }
        match(:num)
      end

      rule :num do
        match(Integer) { |m| m }
      end

      rule :logic_expr do
        match(:logic_expr, :and, :logic_expr) { |a, b, c| Reloperators.new(a, b, c)}
        match(:logic_expr, :or, :logic_expr) { |a, b, c| Reloperators.new(a, b, c)}
        match(:not, :logic_expr) { |a, b| Reloperators.new(b, a)}
        match(:logic_expr, :equal, :logic_expr) { |a, b, c| Reloperators.new(a, b, c)}
        match(:logic_expr, :greater, :logic_expr) { |a, b, c| Reloperators.new(a, b, c)}
        match(:logic_expr, :eqlgreater, :logic_expr) { |a, b, c| Reloperators.new(a, b, c)}
        match(:logic_expr, :less, :logic_expr) { |a, b, c| Reloperators.new(a, b, c)}
        match(:logic_expr, :eqlless, :logic_expr) { |a, b, c| Reloperators.new(a, b, c)}
        match(:arithmetic_expr)
        match(:logic_term) { |a| a }
      end

      rule :logic_term do
        match(:true) { |_| true }
        match(:false) { |_| false }
      end

    end
  end

  def done(str)
    ["quit","exit","bye",""].include?(str.chomp)
  end

  def run
    print "[CodEng] "
    str = gets
    if done(str) then
      puts "Bye."
    else
      puts "=> #{@CodEngParser.parse(str).assess}"
      run
    end
  end

  def log(state = true)
    if state
      @CodEngParser.logger.level = Logger::DEBUG
    else
      @CodEngParser.logger.level = Logger::WARN
    end
  end
end

a = CodEng.new
a.run
