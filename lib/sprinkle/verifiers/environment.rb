module Sprinkle
  module Verifiers
    # = Environment Verifier
    #
    # Contains a verifier to check environment variables
    #
    # == Example Usage
    #
    #   verify { has_environment_variable "PATH" }
    #   verify { has_environment_variable "ProgramFiles", "C:\\Program Files" }
    #
    module Environment
      Sprinkle::Verify.register(Sprinkle::Verifiers::Environment)

      # Checks to make sure the <tt>environment variable</tt> exists or has a specific value 
      def has_environment_variable(name, value = nil)
        if RUBY_PLATFORM =~ /win32/
          command = value.nil? "if \"%#{name}%\" == "" (exit 1) else (exit 0)" : "if \"%#{name}%\" == \"#{value.escape_for_win32_shell}\" (exit 0) else (exit 1)"
          command += ' > NUL 2>&1' unless logger.debug?
        else
          command = value.nil? ? "test -n $#{name}" : "test $#{name} == \"value\""
        end
        @commands << command
      end
      
      # Checks to make sure the <tt>environment variable</tt> contains the given text 
      def environment_variable_contains(name, text)
        if RUBY_PLATFORM =~ /win32/
          command = "echo \"%#{name}%\" | findstr /c:\"#{text}\""
          command += ' > NUL 2>&1' unless logger.debug?
        else
          command = "echo $#{name} | grep '#{text}'"
        end
        @commands << command
      end

    end
  end
end