module Sprinkle
  module Actors
    # = Psexec Delivery Method
    #
    # Windows specific remote delivery method, using the psexec.exe tool
    # (which must be on the path of your local machine):
    # http://technet.microsoft.com/en-us/sysinternals/bb896649.aspx.
    #
    # A minimal configuration for this delivery method would specify the
    # role to be applied to some host:
    #
    #   deployment do
    #     delivery :psexec do
    #       role :app, 'app.example.com'
    #     end
    #   end
    #
    # A more complex example could define multiple roles and a specific user:
    #
    #   deployment do
    #     delivery :psexec do
    #       role :app, 'app.example.com'
    #       role :web, 'web.example.com'
    #       # you can also specify a password, but if
    #       # not provided you will be prompted for it
    #       user 'domain\\administrator', 'opensesame'
    #     end
    #   end
    class Psexec
      attr_accessor :options

      def initialize(options = {}, &block) #:nodoc:
        @options = {:roles => {}}.merge options
        self.instance_eval &block if block
      end

      def role(name, *host)
        @options[:roles][name] = host
      end

      def roles(roles)
        @options[:roles] = roles
      end
            
      def user(name, pass = nil)
        @options[:user], @options[:password] = name, pass
      end
      
      def process(name, commands, roles, suppress_and_return_failures = false)        
        Array(roles).each do |role| 
          Array(@options[:roles][role]).each do |host|
            Array(commands).each do |command|
              begin
                psexec(host, command)
              rescue RuntimeError => e
                return false if suppress_and_return_failures
                raise
              end
            end
          end
        end
        return true
      end
      
      protected
      
      # execute a command against a remote windows machine using psexec
      def psexec(host, command)
        exec = "psexec \\\\#{Array(host).join ','}"
        if @options[:user]
          exec << " -u \"#{@options[:user]}\""
          @options[:password] = ask("--> Enter password for #{@options[:user]}@#{host}: ") {|q| q.echo = '*'} unless @options[:password]
          exec << " -p \"#{@options[:password]}\""
        end
        exec << " /accepteula"
        exec << " cmd /c \"#{command}\""
        exec << ' > NUL 2>&1' unless logger.debug?
        logger.debug "--> #{exec}"
        system exec
        raise "Failed to execute command \"#{command}\" on host: #{host}" if $?.to_i != 0
      end
      
    end
  end
end
