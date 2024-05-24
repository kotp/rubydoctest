$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'lines'

module Rubydoctest
  class Result < Lines
    
    def normalize_result(s)
      s.gsub(/:0x[a-f0-9]{8}>/, ':0xXXXXXXXX>').strip
    end
    
    def expected_result
      @expected_result ||=
        begin
          lines.first =~ /^#{Regexp.escape(indentation)}=>\s(.*)$/
          ([$1] + (lines[1..-1] || [])).join("\n")
        end
    end
    
    # === Tests
    # doctest: Strings should match
    # >> r = Rubydoctest::Result.new(["=> 'hi'"])
    # >> r.matches? 'hi'
    # => true
    #
    # >> r = Rubydoctest::Result.new(["=> \"hi\""])
    # >> r.matches? "hi"
    # => true
    #
    # doctest: Regexps should match
    # >> r = Rubydoctest::Result.new(["=> /^reg.../"])
    # >> r.matches? /^reg.../
    # => true
    #
    # >> r = Rubydoctest::Result.new(["=> /^reg.../"])
    # >> r.matches? /^regexp/
    # => false
    #
    # doctest: Arrays should match
    # >> r = Rubydoctest::Result.new(["=> [1, 2, 3]"])
    # >> r.matches? [1, 2, 3]
    # => true
    #
    # doctest: Arrays of arrays should match
    # >> r = Rubydoctest::Result.new(["=> [[1, 2], [3, 4]]"])
    # >> r.matches? [[1, 2], [3, 4]]
    # => true
    #
    # doctest: Hashes should match
    # >> r = Rubydoctest::Result.new(["=> {:one => 1, :two => 2}"])
    # >> r.matches?({:two => 2, :one => 1})
    # => true
    def matches?(actual_result)
      normalize_result(actual_result.inspect) ==
      normalize_result(expected_result) \
        or
      actual_result == eval(expected_result, TOPLEVEL_BINDING)
    rescue Exception
      false
    end
  end
end