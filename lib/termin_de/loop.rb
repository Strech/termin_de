require "logger"

module TerminDe
  class Loop
    # NOTE : We don't want to be limited by service protection
    REQUEST_INTERVAL_IN_SECONDS = 120

    def initialize(options)
      @options = options
      @fails = 0

      @logger = Logger.new(STDOUT)
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      @logger.level = Logger::INFO
    end

    def run
      infinitly do
        calendar = Calendar.new(@options)

        if calendar.has_earlier?
          termin = calendar.earlier_termin
          @logger.info "Found new [#{termin.date}] → #{termin.link}"

          %x{#{@options.command % termin.to_h}} if @options.command_given?
        else
          @logger.info "Nothing ..."
        end

        sleep(REQUEST_INTERVAL_IN_SECONDS)
      end
    end

    private

    def infinitly
      loop do
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
      num = (Math.log10(fails) * REQUEST_INTERVAL_IN_SECONDS/2 + REQUEST_INTERVAL_IN_SECONDS).to_i
      @logger.warn "Woooops, slow down ... pause for #{num} seconds"
      sleep(num)
    end
  end
end
