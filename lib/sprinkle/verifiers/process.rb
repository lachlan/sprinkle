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
        process = process.to_s
        if RUBY_PLATFORM =~ /win|mingw/
          command = "tasklist /fo table /nh | findstr /c:\"#{process}\""
          command << ' > NUL 2>&1' unless logger.debug?
        else
          command = "ps aux | grep '#{process}' | grep -v grep"
        end
        @commands << command
      end
    end
  end
end