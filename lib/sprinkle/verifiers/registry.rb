module Sprinkle
  module Verifiers
    # = Registry Verifier
    #
    # Contains a verifier to check a Win32 registry setting.
    #
    # == Example Usage
    #
    #   verify { has_registry_key "HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Run" }
    #
    module Registry
      Sprinkle::Verify.register(Sprinkle::Verifiers::Registry)

      # Checks to make sure the <tt>registry</tt> key exists
      def has_registry_key(key)
        key = key.to_s
        if RUBY_PLATFORM =~ /win32/
          command = "reg query \"#{key}\" 2>&1 | findstr /i /c:\"#{key}\""
          command << ' > NUL 2>&1' unless logger.debug?
        else
          raise NotImplementedError, "Non-win32 platforms do not support checking for registry settings"
        end
        @commands << command
      end

      # Checks to make sure the <tt>registry</tt> value exists
      def has_registry_value(key, name, value)
        key, name, value = key.to_s, name.to_s, value.to_s
        if RUBY_PLATFORM =~ /win32/
          if value.empty?
            # The regular expression includes a [\t ], which is a tab character and a space.
            # XP delimits the output with 1 tab, Win2003 trails with 4 spaces!
            # Note: Checking for blank and a value of space(s) will report a false positive.
            command = "reg query \"#{key}\" /v \"#{name}\" | findstr /r /c:\"^.*#{Regexp.quote name}.*REG_[A-Z]*[\t ]*$"
          else
            command = "reg query \"#{key}\" /v \"#{name}\" | findstr /r /c:\"^.*#{Regexp.quote name}.*REG_[A-Z]*[\t ]*#{Regexp.quote value}$"
          end
          command << ' > NUL 2>&1' unless logger.debug?
        else
          raise NotImplementedError, "Non-win32 platforms do not support checking for registry settings"
        end
        @commands << command
      end
    end
  end
end