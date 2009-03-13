module Sprinkle
  module Verifiers
    # = File Verifier
    #
    # Contains a verifier to check the existance of a file.
    # 
    # == Example Usage
    #
    #   verify { has_file '/etc/apache2/apache2.conf' }
    #
    #   verify { file_contains '/etc/apache2/apache2.conf', 'mod_gzip'}
    #
    module File
      Sprinkle::Verify.register(Sprinkle::Verifiers::File)
      
      # Checks to make sure <tt>path</tt> is a file on the remote server.
      def has_file(path)
        if RUBY_PLATFORM =~ /win32/
          command =  "dir /b /a-d \"#{path}\""
          command += ' > NUL' unless logger.debug?
        else
          command << "test -f #{path}"
        end
        @commands << command
      end
      
      def file_contains(path, text)
        if RUBY_PLATFORM =~ /win32/
          command = "find \"#{text}\" \"#{path}\""
          command += ' > NUL' unless logger.debug?
        else
          command = "grep '#{text}' #{path}"
        end
        @commands << command
      end
    end
  end
end