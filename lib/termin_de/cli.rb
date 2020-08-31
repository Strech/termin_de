# frozen_string_literal: true

require 'optparse'
require 'date'

module TerminDe
  # command line interface
  class Cli
    DEFAULT_DATE = Date.new(3000, 0o1, 0o1)
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
        !command.nil?
      end

      alias_method :dry_run?, :dry_run
    end

    def opt_parser
      OptionParser.new do |parser|
        parser.banner = "Burgeramt termin monitor\nUsage: termin [options]"
        parser.version = VERSION

        parser.on('-b', '--before=<date>', String, 'Trigger only on date earlier than given date') do |date|
          @options.before_date = begin
                                   Date.parse(date)
                                 rescue StandardError
                                   DEFAULT_DATE
                                 end
        end

        parser.on('-c', '--execute=<command>', String, 'Run given command with %{date} and %{link} replacements') do |command|
          @options.command = command
        end

        parser.on('--dry-run', 'Run on saved examples') do
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
