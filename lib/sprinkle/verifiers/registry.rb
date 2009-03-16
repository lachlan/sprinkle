module Sprinkle
  module Verifiers
    # = Process Verifier
    #
    # Contains a verifier to check a Win32 registry setting.
    #
    # == Example Usage
    #
    #   verify { has_registry_key "path", "name", "value" }
    #
    module Registry
      Sprinkle::Verify.register(Sprinkle::Verifiers::Registry)

      # Checks to make sure the <tt>registry</tt> key exists
      def registry_has_key(key)
        if RUBY_PLATFORM =~ /win32/
          command = "reg query \"#{key}\" 2>&1 | find \"! REG.EXE VERSION\""
          command += ' > NUL' unless logger.debug?
        else
          raise NotImplementedError, "Non-win32 platforms do not support checking for registry settings"
        end
        @commands << command
      end

      # Checks to make sure the <tt>registry</tt> value exists
      def registry_has_value(key, name, value)
        if RUBY_PLATFORM =~ /win32/
          command = "reg query \"#{key}\" /v \"#{name}\" | find \"#{value}\""
          command += ' > NUL' unless logger.debug?
        else
          raise NotImplementedError, "Non-win32 platforms do not support checking for registry settings"
        end
        @commands << command
      end
    end
  end
end