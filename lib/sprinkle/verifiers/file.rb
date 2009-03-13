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
          @commands << "dir /b /a-d \"#{path}\" > NUL"
        else
          @commands << "test -f #{path}"
        end
      end
      
      def file_contains(path, text)
        if RUBY_PLATFORM =~ /win32/
          @commands << "find \"#{text}\" \"#{path}\" > NUL"
        else
          @commands << "grep '#{text}' #{path}"
        end
      end
    end
  end
end