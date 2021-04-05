# frozen_string_literal: true

require 'optparse'
require 'date'

module TerminDe
  # command line interface
  class Cli
    DEFAULT_DATE = Date.new(3000, 0o1, 0o1)
    DEFAULT_DRY_RUN = false
    # default request for id card
    DEFAULT_SERVICE = '120703'
    BURGERAMT_IDS = [
      # ALL '122210,122217,327316,122219,327312,122227,122231,327346,122238,122243,327348,122252,329742,122260,329745,122262,329748,122254,329751,122271,327278,122273,122277,327276,122280,327294,122282,327290,122284,327292,122291,327270,122285,327266,122286,327264,122296,327268,327262,325657,150230,329760,122301,327282,122297,327286,122294,327284,122312,329763,122304,327330,122311,327334,122309,327332,317869,324434,122281,327352,122279,122276,327324,122274,327326,122267,329766,122246,327318,122251,327320,327653,122257,327322,122208,122226'
      '122243', # Friedrichshain Frankfurter
      '122238', # Friedrichshain Schlesisches Tor
      '122260', # Lichtenberg Moellendorfstr
      '122262' # Lichtenberg TierparkCenter
    ]

    def initialize(argv)
      @argv = argv
      @options = Options.new(DEFAULT_DATE, DEFAULT_DRY_RUN, DEFAULT_SERVICE, BURGERAMT_IDS)
    end

    def start
      opt_parser.parse!(@argv)
      Loop.new(@options).run
    end

    private

    Options = Struct.new(:before_date, :dry_run, :service, :burgeramt, :command) do
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

        parser.on('-s', '--service=<id>', String, 'Id of the requested service') do |id|
          @options.service = !id.nil? ? id : DEFAULT_SERVICE
        end

        parser.on('-u', '--burgeramt=<bid>', String, 'Id of the burgeramt') do |id|
          @options.burgeramt = id.nil? ? BURGERAMT_IDS : id
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
