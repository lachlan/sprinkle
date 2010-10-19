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
        @commands << "test -f #{path}"
      end
      
      def file_contains(path, text)
        @commands << "grep '#{text}' #{path}"
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
