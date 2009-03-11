module Sprinkle
  module Installers
    # = Script Installer
    #
    # The Script installer runs a script file to install software
    #
    # == Example Usage
    #
    #   package :magic_beans do
    #     script '/some/path/to/install/script/for/magic_beans'
    #   end
    class Script < Installer
      attr_accessor :script, :path #:nodoc:

      def initialize(parent, script, path, options={}, &block) #:nodoc:
        super parent, options, &block
        @script = script
        @path = path
      end

      protected

        def install_commands #:nodoc:
          delim = RUBY_PLATFORM =~ /win32/ ? ' & ' : '; '
          "pushd \"#{path}\"#{delim}#{script}#{delim}popd"
        end

      end
  end
end
