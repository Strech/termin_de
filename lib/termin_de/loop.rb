# frozen_string_literal: true

require 'logger'
require 'yaml'

module TerminDe
  # Endless loop for querying the burgeramt webpage
  class Loop

    def initialize(options)
      @options = options
      @fails = 0

      @logger = Logger.new(STDOUT)
      @logger.datetime_format = '%Y-%m-%d %H:%M:%S'
      @logger.level = options.verbose ? Logger::DEBUG : Logger::INFO

      @logger.debug "Starting with options:\n#{options.to_h.to_yaml}"

    end

    def run
      infinitly do
        calendar = Calendar.new(@options)

        if calendar.earlier?
          termin_found(calendar.earlier_termin)
        else
          @logger.info 'Nothing ...'
        end

        sleep(@options.request_interval_in_seconds)
      end
    end

    private

    def infinitly
      loop do
        @logger.info "Looking for available slots before #{@options.before_date}"
        begin
          yield
        rescue Exception => e
          # NOTE : Arrrgh, Curb doesn't nest exceptions
          raise unless e.class.name =~ /Curl/

          @fails += 1
          pause_when(@fails)
        end
      end
    end

    def pause_when(fails)
      num = (Math.log10(fails) * @options.request_interval_in_seconds / 2 + @options.request_interval_in_seconds).to_i
      @logger.warn "Woooops, slow down ... pause for #{num} seconds"
      sleep(num)
    end

    def termin_found(termin)
      @logger.info "Found new [#{termin.date}] → #{termin.link}"
      `#{@options.command % termin.to_h}` if @options.command_given?
    end
  end
end
