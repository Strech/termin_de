require "optparse"

module TerminDe
  class Cli
    DEFAULT_DATE = Date.new(3000, 01, 01)
    DEFAULT_DRY_RUN = false

    def initialize(argv)
      @argv = argv
      @options = Options.new(DEFAULT_DATE, DEFAULT_DRY_RUN)
    end

    def start
      opt_parser.parse!(@argv)
      Loop.new(@options).run
    end

    private

    Options = Struct.new(:before_date, :dry_run, :command) do
      def command_given?
        !!command
      end

      alias_method :dry_run?, :dry_run
    end

    def opt_parser
      OptionParser.new do |parser|
        parser.banner = "Burgeramt termin monitor\nUsage: termin [options]"
        parser.version = VERSION

        parser.on("-b", "--before=<date>", String, "Trigger only on date earlier than given date") do |date|
          @options.before_date = Date.parse(date) rescue DEFAULT_DATE
        end

        parser.on("-c", "--execute=<command>", String, "Run given command with %{date} and %{link} replacements") do |command|
          @options.command = command
        end

        parser.on("--dry-run", "Run on saved examples") do
          @options.dry_run = true
        end

        parser.on_tail('--version', 'Display the version') do
          puts "Burgeramt termin monitor. Version #{parser.version}"
          exit
        end
      end
    end
  end
end
