$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'statement'
require 'result'

module Rubydoctest
  # A +CodeBlock+ is a group of one or more ruby statements, followed by an optional result.
  # For example:
  #  >> a = 1 + 1
  #  >> a - 3
  #  => -1
  class CodeBlock
    attr_reader :statements, :result, :passed
    
    def initialize(statements = [], result = nil)
      @statements = statements
      @result = result
    end
    
    # === Tests
    # doctest: Single statement with result should pass
    # >> ss = [Rubydoctest::Statement.new([">> a = 1"])]
    # >> r = Rubydoctest::Result.new(["=> 1"])
    # >> cb = Rubydoctest::CodeBlock.new(ss, r)
    # >> cb.pass?
    # => true
    #
    # doctest: Single statement without result should pass by default
    # >> ss = [Rubydoctest::Statement.new([">> a = 1"])]
    # >> cb = Rubydoctest::CodeBlock.new(ss)
    # >> cb.pass?
    # => true
    #
    # doctest: Multi-line statement with result should pass
    # >> ss = [Rubydoctest::Statement.new([">> a = 1"]),
    #          Rubydoctest::Statement.new([">> 'a' + a.to_s"])]
    # >> r = Rubydoctest::Result.new(["=> 'a1'"])
    # >> cb = Rubydoctest::CodeBlock.new(ss, r)
    # >> cb.pass?
    # => true
    def pass?
      if @computed
        @passed
      else
        @computed = true
        @passed =
          begin
            actual_results = @statements.map{ |s| s.evaluate }
            @result ? @result.matches?(actual_results.last) : true
          end
      end
    end
    
    def actual_result
      @statements.last.actual_result
    end
    
    def expected_result
      @result.expected_result
    end
    
    def lines
      @statements.map{ |s| s.lines }.flatten +
      @result.lines
    end
  end
end