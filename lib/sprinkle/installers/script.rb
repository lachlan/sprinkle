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
      attr_accessor :script_file, :script_path #:nodoc:
      @@command_delimiter = (RUBY_PLATFORM =~ /win|mingw/ ? ' & ' : '; ')

      def initialize(parent, name, options={}, &block) #:nodoc:
        super parent, options, &block
        @script_path, @script_file = File.split name
      end

      protected

        def install_commands #:nodoc:
          commands = []
          commands << "pushd \"#{@script_path}\"" if @script_path
          
          command = @script_file
          command << ' > NUL' if RUBY_PLATFORM =~ /win|mingw/ and not logger.debug?
          commands << command

          commands << "popd" if @script_path

          commands.join(@@command_delimiter)
        end

      end
  end
end
