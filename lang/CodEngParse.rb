require_relative 'rdparse.rb'

class CodEng

  def initialize
    @CodEngParser = Parser.new( "CodEng") do
      token(/\s+/)
      token(/\d+/) { |t| t.to_i }
      token(/\*\*|to the power of/) { :exponent }
      token(/\+|plus/) { :plus }
      token(/-|minus/) { :minus }
      token(/\*|times/) { :mult }
      token(/\/|over/) { :div }
      token(/-[\d]+/) { :negative }
      token(/[a-zA-Z_]+/) { |t| t }
      token(/./) { |t| t }

      start :valid do
        match(:assign) { |m| m }
        match(:expr) { |m| m }
      end

      rule :assign do
        match(:var, '=', :expr) { |var, _, expr| @vars[var] = expr }
        match(:prefix, :var, 'is', :expr) { |_, var, _, expr| @vars[var] = expr } #
      end

      rule :prefix do
      end

      rule :expr do
        match(:arithmatic_expr)
        match(:logic_expr)
      end

      rule :arithmetic_expr do
        match(:arithmetic_expr, :plus, :term) { |a, _, b| a + b }
        #match('add', :arithmetic_expr, 'to', :term) { |_, a, _, b| a + b }
        match(:arithmetic_expr, :minus, :term) { |a, _, b| a - b }
        #match('subtract', :arithmetic_expr, 'from', :term) { |_, a, _, b| a - b }
        match(:term) { |m| m }
      end

      rule :term do
        match(:term, :mult, :factor) { |a, _, b| a * b }
        match('multiply', :term, 'by', :factor) { |_, a, _, b| a * b }
        match(:term, :div, :factor) { |a, _, b| a / b }
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

      #rule :unary do
      #  match(:negative) { |}
      #  match(:var) { |m| m }
      #end

      rule :var do
        match(/[a-zA-z]{1}\w*/) { |var| @vars.key?(var) ? @vars[var] : var }
        match(:num)
      end

      rule :num do
        match(Integer) { |m| m }
      end

      rule :logic_expr do
        match(:logic_expr, 'or', :logic_expr) { |a, _, c| a || c }
        match(:logic_expr, 'and', :logic_expr) { |a, _, c| a && c }
        match('not', :logic_expr) { |_, a| !a }
        match(:logic_term) { |a| a }
      end

      rule :logic_term do
        match('true') { |_| true }
        match('false') { |_| false }
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
      puts "=> #{@CodEngParser.parse str}"
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
