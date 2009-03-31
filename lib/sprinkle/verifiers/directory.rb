module Sprinkle
  module Verifiers
    # = Directory Verifier
    #
    # Defines a verify which can be used to test the existence of a 
    # directory.
    module Directory
      Sprinkle::Verify.register(Sprinkle::Verifiers::Directory)
      
      # Tests that the directory <tt>dir</tt> exists.
      def has_directory(dir)
        dir = dir.to_s
        if RUBY_PLATFORM =~ /win32/
          dir += "\\" unless dir[-1,1] == "\\"
          command = "if exist \"#{dir}\" (exit 0) else (exit 1)"
          command << ' > NUL 2>&1' unless logger.debug?
        else
          command = "test -d #{dir}"
        end
        @commands << command
      end
      
    end
  end
end