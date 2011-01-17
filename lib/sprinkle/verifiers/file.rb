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
        path = path.to_s
        if ENV['os'] =~ /win/i
          command = "if exist \"#{path}\" (if not exist \"#{path}\\\" (exit 0) else (exit 1)) else (exit 1)"
          command << ' > NUL 2>&1' unless logger.debug?
        else
          command = "test -f #{path}"
        end
        @commands << command
      end
      
      def file_contains(path, text)
        path, text = path.to_s, text.to_s
        if ENV['os'] =~ /win/i
          command = "findstr /m /c:\"#{text}\" \"#{path}\""
          command << ' > NUL 2>&1' unless logger.debug?
        else
          command = "grep '#{text}' #{path}"
        end
        @commands << command
      end
      def user_present(username) 
        @commands << %Q{grep -q -e  \'^#{username}:x\' /etc/passwd && test -d ~#{username}}
      end
      def matches_local(localfile, remotefile, mode=nil)
        raise "Couldn't find local file #{localfile}" unless ::File.exists?(localfile)
        local = `md5 #{localfile}`.split.last
        @commands << %{[ "X$(md5sum #{remotefile}|cut -d\\  -f 1)" = "X#{local}" ]}
      end
    end
  end
end
