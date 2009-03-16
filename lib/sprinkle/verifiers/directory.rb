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
        if RUBY_PLATFORM =~ /win32/
          dir += "\\" unless dir[-1,1] == "\\"
          command = "if exist \"#{dir}\" (set errorlevel=0) else (set errorlevel=1)"
          command += ' > NUL' unless logger.debug?
        else
          command = "test -d #{dir}"
        end
        @commands << command
      end
    end
  end
end