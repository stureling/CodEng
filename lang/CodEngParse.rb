#!/usr/bin/env ruby

require_relative 'rdparse.rb'
require_relative 'CodEngNodes.rb'

class CodEng

  @@root_scope = CEScope.new('root')

  def initialize
    @CodEngParser = Parser.new( "CodEng") do
      token(/\s+/)
      token(/-?\d+\.\d+/) { |t| t.to_f }
      token(/-?\d+/) { |t| t.to_i }
      token(/start|begin/) { :start }
      token(/stop|end/) { :stop }
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
      token(/!=|not equal to/) { :notequal }
      token(/==|equal to/) { :equal }
      token(/>|greater than/) { :greater }
      token(/>=|equal or greater than|greater than or equal to/) { :eqlgreater }
      token(/<|less than/) { :less }
      token(/<=|equal or less than|less than or equal to/) { :eqllesser }
      token(/=|is/) { |t| t }
      token(/[a-zA-Z_]+/) { |t| t }
      token(/./) { |t| t }

      start :program do
        match(:statements) { |m| m.assess(@@root_scope) } #assess all statements in the list
        #match('start', :statements, 'stop') { |_, m, _| m }
        #match(start, :statements, :block, stop) { |_, a, b, _| a, b }
      end
      
      rule :statements do
        match(:statements, :statement) { |master_list, list| master_list.concat(list) }
        match(:statement) { |m| m }
      end

      rule :statement do
        match(:matched) { |m| m }
        match(:unmatched) { |m| m }
      end

      rule :unmatched do
        match('', :expr, 'then' :statement) { |_, l, _, s| CEIfStatement.new(l, s)}
        match('', :expr, 'then' :matched 'else' :statement) { |_, l, _, m, _, s| CEIfElseStatement.new(l, m, s)}
      end

      rule :matched do
        match('', :expr, 'then' :matched 'else' :matched) { |_, l, _, m1, _, m2| CEIfElseStatement.new(l, m1, m2)}
        match(:for_loop) { |m| m }
        match(:while_loop) { |m| m}
        match(:valid) { |m| m }
      end

      rule :valid do
        match(:assign) { |m| m }
        match(:expr) { |m| m }
      end

      rule :assign do
        match(:var, '=', :expr) { |var, _, expr| CEVarAssignNode.new(var, expr) }
        #match(:prefix, :var, 'is', :expr) { |_, var, _, expr| @vars[var] = expr } #
      end

      rule :prefix do
      end

      rule :expr do
        match(:logic_OR) { |m| m }
      end

      rule :logic_OR do
        match(:logic_OR, :or ,:logic_AND) { |a, _, b| CELogicORNode.new(a, b) }
        match(:logic_AND) { |m| m }
      end

      rule :logic_AND do
        match(:logic_AND, :and ,:compare_equality) { |a, _, b| CELogicANDNode.new(a, b) }
        match(:compare_equality) { |m| m }
      end

      rule :compare_equality do
        match(:compare_equality, :equal ,:compare_relops) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:compare_equality, :notequal ,:compare_relops) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:compare_relops) { |m| m }
      end

      rule :compare_relops do
        match(:compare_relops, :less ,:arithmetic_expr) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:compare_relops, :eqlless ,:arithmetic_expr) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:compare_relops, :greater ,:arithmetic_expr) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:compare_relops, :eqlgreater ,:arithmetic_expr) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:arithmetic_expr) { |m| m }
      end

      rule :arithmetic_expr do
	      match(:arithmetic_expr, :plus, :term) { |a, b, c| CEArithmeticOpNode.new(a, b, c) }
        match('add', :arithmetic_expr, 'to', :term) { |_, a, _, b| CEArithmeticOpNode.new(a, :plus, b) }
        match(:arithmetic_expr, :minus, :term) { |a, b, c| CEArithmeticOpNode.new(a, b, c) }
        match('subtract', :arithmetic_expr, 'from', :term) { |_, a, _, b| CEArithmeticOpNode.new(a, :minus, b) }
        match(:term) { |m| m }
      end

      rule :term do
	      match(:term, :mult, :factor) { |a, b, c| CEArithmeticOpNode.new(a, b, c) }
        match('multiply', :term, 'by', :factor) { |_, a, _, b| CEArithmeticOpNode.new(a, :mult, b) }
	      match(:term, :div, :factor) { |a, b, c| CEArithmeticOpNode.new(a, b, c) }
        match('divide', :term, 'by', :factor) { |_, a, _, b| CEArithmeticOpNode.new(a, :div, b) }
        match(:factor) { |m| m }
      end

      rule :factor do
        match(:exp, :exponent, :factor) { |a, b, c| CEArithmeticOpNode.new(a, b, c) }
        match(:not, :exp) { |_, m| CENotNode.new(m)}
        match(:exp) { |m| m }
      end

      rule :exp do
        match('(', :expr, ')') { |_, m, _| m }
        match(:bool_const) { |m| m }
        match(:var) { |m| m }
      end

      rule :var do
        match(/[a-zA-z]{1}\w*/) { |var| CEVariable.new(var,) }
        match(:num)
      end

      rule :num do
        match(Integer) { |m| CEInteger.new(m) }
        match(Float) { |m| CEFloat.new(m) }
      end

      rule :bool_const do
        match(:true) { |_| CEBool.new(true) }
        match(:false) { |_| CEBool.new(false) }
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
      puts "=> #{@CodEngParser.parse(str)}"
      run
    end
  end

  def parse_file_by_line(filename)
    f = File.new(filename)
    lines = f.readlines
    i = 0
    answers = {}
    while i < lines.length
      str = lines[i]
      if str == "\n"
        i += 1
      elsif str.include?("#")
        # will see everything with # in front of it as comments
        # even in strings
        index = str.index("#")
        if index > 0 then
          str = str.slice(0...index)
          answers[(i + 1)] = "#{@CodEngParser.parse(str).value}"
          i += 1
        else
          i += 1
        end
      else
        answers[(i + 1)] = "#{@CodEngParser.parse(str).value}"
        i += 1
      end
    end
    answers.each{|key,value|puts "Answer for row number #{key} is: #{value}"}
    puts "#{filename} has been successfully parsed."
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
a.parse_file_by_line("testfile.txt")
