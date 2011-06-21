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
        if ENV['os'] =~ /win/i
          dir += "\\" unless dir[-1,1] == "\\"
          # if the dir exists and we can list it then its a directory
          command = "dir /ad \"#{dir}\" > NUL 2>&1 & if errorlevel 1 (exit 1) else (exit 0)"          
          command << ' > NUL 2>&1' unless logger.debug?
        else
          command = "test -d #{dir}"
        end
        @commands << command
      end
      
    end
  end
end