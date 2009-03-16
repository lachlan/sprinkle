module Sprinkle
  module Verifiers
    # = Process Verifier
    #
    # Contains a verifier to check that a process is running.
    #
    # == Example Usage
    #
    #   verify { has_process 'httpd' }
    #
    module Process
      Sprinkle::Verify.register(Sprinkle::Verifiers::Process)

      # Checks to make sure <tt>process</tt> is a process running
      # on the remote server.
      def has_process(process)
        if RUBY_PLATFORM =~ /win32/
          command = "tasklist /fo table /nh | find \"#{process}\""
          command += ' > NUL' unless logger.debug?
        else
          command = "ps aux | grep '#{process}' | grep -v grep"
        end
        @commands << command
      end
    end
  end
end