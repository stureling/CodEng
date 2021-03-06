#!/usr/bin/env ruby

require_relative 'rdparse_debug.rb'
require_relative 'CodEngNodes.rb'

class CodEng
  attr_accessor :CodEngParser

  
  def initialize
    @CodEngParser = Parser.new( "CodEng") do
      #Whitespaces
      token(/\s+/)

      #Comments
      token(/#.*\\n/)
      token(/""".*"""/)
      
      #Strings
      token(/"[^"]*"/) { |t| CEString.new(t[1...-1])}
      
      #Numbers
      token(/^-?\d+\.\d+/) { |t| CEFloat.new(t.to_f) }
      token(/^-?\d+/) { |t| CEInteger.new(t.to_i) }
      
      #Boolean values
      token(/true/) { CEBool.new(true) }
      token(/false/) { CEBool.new(false) }

      #Arrays
      token(/list/) { CEArray.new() }

      #Keywords
      token(/stop/) { :stop }
      token(/end/) { :stop }
      token(/call/) { :call }
      token(/do/) { :do }
      token(/with/) { :with }
      token(/define/) { :define }
      token(/while/) { :while }
      token(/if/) { :if }
      token(/else/) { :else }
      token(/then/) { :then }
      token(/shout/) { :puts }
      token(/say/) { :print }
      token(/\(/) {:left_para}
      token(/\)/) {:right_para}
      token(/,/) {:comma}
      token(/nothing/) {CENil.new}
      token(/empty/) {CENil.new}
      token(/return/) {:return}
      token(/local/) {:var_decl}
      
      #Operators
      token(/\*\*/) { :exponent }
      token(/to the power of/) { :exponent }
      token(/\+/) { :plus }
      token(/plus/) { :plus }
      token(/-/) { :minus }
      token(/minus/) { :minus }
      token(/\*/) { :mult }
      token(/times/) { :mult }
      token(/\//) { :div }
      token(/over/) { :div }
      token(/&&/) { :and }
      token(/and/) { :and }
      token(/\|\|/) { :or }
      token(/or/) { :or }
      token(/!=/) { :notequal }
      token(/not equal to/) { :notequal }
      token(/==/) { :equal }
      token(/equal to/) { :equal }
      token(/<=/) { :less_or_eql }
      token(/less than or equal to/) { :less_or_eql }
      token(/>=/) { :greater_or_eql }
      token(/greater than or equal to/) { :greater_or_eql }
      token(/!/) { :not }
      token(/not/) { :not }
      token(/>/) { :greater }
      token(/greater than/) { :greater }
      token(/</) { :less }
      token(/less than/) { :less }
      token(/=/) { :assign_operator }
      token(/is/) { :assign_operator }

      #Lists
      token(/place/) { :place }
      token(/append/) { :append }
      token(/element/) { :element }
      token(/remove/) { :remove }
      token(/get/) { :get }
      token(/size/) { :size }
      token(/to/) { :to }
      token(/of/) { :of }
      token(/in/) { :in }
      token(/at/) { :at }


      #Variables
      token(/[a-zA-Z_0-9]+/) { |t| CEVariable.new(t) }

      #Exceptions
      token(/./) { |t| raise "#{t} is not a keyword or valid variable name, unable to lex" }

      start :program do
        match(:block) {|statements| CEProgramNode.new(statements) }
      end

      rule :block do
        match(:block, :statement) do |block, statement| 
          if statement.class != Array
            block.concat([statement])
          else
            block.concat(statement)
          end
        end
        match(:statement) { |m| [m] } 
      end

      rule :statement do
        match(:if_statement) { |m| m }
        match(:func_def) { |m| m }
        match(:while_loop) { |m| m}
        match(:print_statement) { |m| m }
        match(:return_statement) { |m| m }
        match(:valid) { |m| m }
      end

      rule :if_statement do
        match(:if, :expr, :then, :block, :stop) { |_, l, _, s, _| CEIfStatementNode.new(l, s)}
        match(:if, :expr, :then, :block, :else, :block, :stop) do
          |_, l, _, m, _, s, _| 
          CEIfElseStatementNode.new(l, m, s)
        end
      end

      rule :func_def do
        match(:define, CEVariable, :with, :arg_list, :do, :block, :stop) do 
          |_, name, _, arg_list, _, block, _| 
            CEFunctionDefNode.new(name.name, block, arg_list)
        end
        match(:define, CEVariable, :do, :block, :stop) do 
          |_, name, _, block, _| 
            CEFunctionDefNode.new(name.name, block)
        end
      end

      rule :while_loop do
        match(:while, :expr, :do, :block, :stop) do 
          |_, condition, _, block, _| 
          CEWhileLoopNode.new(condition, block)
        end
      end

      rule :print_statement do
        match(:print, :arg_list) { |_, block| CEPrintNode.new(block) }
        match(:puts, :arg_list) { |_, block| CEPrintNode.new(block, true) }
      end

      rule :return_statement do
        match(:return, :statement) { |_, expr| CEReturn.new(expr) }
      end

      rule :valid do
        match(:assign) { |m| m }
        match(:expr) { |m| m }
      end

      rule :assign do
        match(:var, :assign_operator, :expr) { |var, _, expr| CEVarAssignNode.new(var, expr) }
      end

      rule :func_call do
        match(:call, :var, :with, :arg_list) { |_, name, _, args| CEFunctionCallNode.new(name, args) }
        match(:call, :var) { |_, name| CEFunctionCallNode.new(name) }
      end

      rule :arg_list do
        match(:arg_list, :comma, :arg_decl) do |arg_list, _, arg|
          if arg.class != Array
            arg_list.concat([arg])
          else
            arg_list.concat(arg)
          end
        end
        match(:arg_decl) { |m| [m] }
      end

      rule :arg_decl do
        match(:valid) { |m| m }
      end

      rule :expr do
        match(:logic_OR) { |m| m }
      end

      rule :list_ops do
        match( :place, :valid, :at, CEInteger, :in, :var ) { |op, expr, _, pos, _, list| CEArrayOpNode.new(op, list, expr, pos) }
        match( :remove, :element, :at, CEInteger, :in, :var ) { |op, _, _, pos, _, list| CEArrayOpNode.new(op, list, CENil.new, pos) }
        match( :append, :valid, :to, :var ) {  |op, expr, _, list| CEArrayOpNode.new(op, list, expr, CENil.new)  }
        match( :get, :element, :at, CEInteger, :in, :var ) {  |op, _, _, pos, _, list| CEArrayOpNode.new(op, list, CENil.new, pos)  }
        match( :size, :of, :var ) {  |op, _, list| CEArrayOpNode.new(op, list)  }
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
        match(:compare_relops, :less_or_eql ,:arithmetic_expr) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:compare_relops, :greater ,:arithmetic_expr) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:compare_relops, :greater_or_eql ,:arithmetic_expr) { |a, b, c| CERelationOpNode.new(a, b, c) }
        match(:arithmetic_expr) { |m| m }
      end

      rule :arithmetic_expr do
	      match(:arithmetic_expr, :plus, :term) { |a, b, c| CEArithmeticOpNode.new(a, b, c) }
        match('add', :arithmetic_expr, 'to', :term) { |_, a, _, b| CEArithmeticOpNode.new(a, :plus, b) }
        match(:arithmetic_expr, :minus, :term) { |a, b, c| CEArithmeticOpNode.new(a, b, c) }
        match('subtract', :arithmetic_expr, 'from', :term) { |_, a, _, b| CEArithmeticOpNode.new(b, :minus, a) }
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
        match(:left_para, :expr, :right_para) { |_, m, _| m }
        match(:bool_const) { |m| m }
        match(:num) { |m| m }
        match(:string) { |m| m }
        match(:var) { |m| m }
        match(:func_call) { |m| m }
        match(:list_ops) { |m| m }
        match(:nil) { |m| m }
      end

      rule :bool_const do
        match(CEBool) { |m| m }
      end

      rule :num do
        match(CEInteger) { |m| m }
        match(CEFloat) { |m| m }
      end

      rule :string do
        match(CEString) { |m| m }
      end

      rule :var do
        match(:var_decl, CEVariable) { |_ ,var| CEVarDeclerationNode.new(var) }
        match(CEVariable) { |var| var }
        match(:list) { |m| m }
      end

      rule :list do
        match(CEArray) { |m| m }
      end

      rule :nil do
        match(CENil) { |m| m }
      end
    end
  end

  def done(str)
    ["quit","exit","bye",""].include?(str.chomp)
  end

  def run(scope)
    # CodEng interactive shell
    print "[CodEng] "
    str = gets
    if done(str) then
      puts "Bye."
    elsif str.chomp == "test"
      str = File.new(File.dirname(__FILE__) + "/test.cod").read
      puts "test => #{@CodEngParser.parse(str).assess(scope).inspect}"
      run(scope)
    else
      puts "=> #{@CodEngParser.parse(str).assess(scope).inspect}"
      run(scope)
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
