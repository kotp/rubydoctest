module Rubydoctest #:nodoc:

  module VERSION #:nodoc:

    MAJOR = 1
    MINOR = 1
    TINY  = 5

    STRING = [MAJOR, MINOR, TINY].join('.')

    def self.to_s
      STRING
    end

  end

end
