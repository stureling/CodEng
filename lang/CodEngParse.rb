require_relative 'rdparse.rb'

class CodEng
        
  def initialize
    @CodEngParser = Parser.new( "CodEng") do
      token(/\s+/)
      token(/\d+/) { |t| t.to_i }
      token(/[a-zA-Z_]+/) { |t| t }
      token(/./) { |t| t }

      start :valid do
        match(:assign) { |m| m }
        match(:expr) { |m| m }
      end

      rule :assign do
        match(:var, '=', :expr) { |a, _, b| } # variable assignment
        match(:prefix, :var, 'is', :expr) { |_, a, _, b| } # variable assignment
      end

      rule :prefix do
      end

      rule :expr do
        match(:arithmatic_expr)
      end

      rule :arithmatic_expr do
        match(:arithmetic_expr, '+', :term) { |a, _, b| a + b }
        match(:arithmetic_expr, 'plus', :term) { |a, _, b| a + b }
        match('add', :arithmetic_expr, 'to', :term) { |_, a, _, b| a + b }
        match(:arithmetic_expr, '-', :term) { |a, _, b| a - b }
        match(:arithmetic_expr, 'minus', :term) { |a, _, b| a - b }
        match('subtract', :arithmetic_expr, 'from', :term) { |_, a, _, b| a - b }
        match(:term) { |m| m }
      end

      rule :term do
        match(:term, '*', :factor) { |a, _, b| a * b }
        match('multiply', :term, 'by', :factor) { |_, a, _, b| a * b }
        match(:term, 'times', :factor) { |a, _, b| a * b }
        match(:term, '/', :factor) { |a, _, b| a / b }
        match(:term, 'over', :factor) { |a, _, b| a / b }
        match('divide', :term, 'by', :factor) { |_, a, _, b| a / b }
        match(:factor) { |m| m }
      end

      rule :factor do
        match(:exp, '**', :factor) { |a, _, b| a**b }
        match(:exp, 'to', 'the', 'power', 'of', :factor) { |a, _, _, _, _, b| a**b }
        match(:exp) { |m| m }
      end

      rule :exp do
        match('(', :expr, ')') { |_, m, _| m }
        match(:var) { |m| m }
      end

      rule :var do
        match(/[a-zA-z]{1}\w*/) { |m| m }
        match(:num)
      end

      rule :num do
        match(Interger) { |m| m }
      end
    end
  end

  def done(str)
    ["quit","exit","bye",""].include?(str.chomp)
  end

  def roll
    print "[CodEng] "
    str = gets
    if done(str) then
      puts "Bye."
    else
      puts "=> #{@CodEngParser.parse str}"
      roll
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
a.roll
