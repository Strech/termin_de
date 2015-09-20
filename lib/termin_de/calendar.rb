require "curb"
require "nokogiri"

module TerminDe
  class Calendar
    SAMPLES_PATH = File.expand_path("../../../samples/calendar.html", __FILE__)
    TERMIN_CSS_PATH = "td.buchbar a".freeze

    attr_reader :booked_termin

    def initialize(options)
      @options = options
      @booked_termin = Termin.new(options.before_date)
    end

    def has_earlier?
      !earlier_termin.link.nil? && earlier_termin.date != booked_termin.date
    end

    def earlier_termin
      @earlier_termin ||= (available_termins | [booked_termin]).min_by(&:date)
    end

    def available_termins
      download_latest_calendar.css(TERMIN_CSS_PATH).map do |link|
        date = Date.parse link.attr(:href).match(/\d{4}-\d{2}-\d{2}/)[0]
        link = "#{Termin::URL}/#{link.attr(:href).sub(Termin::BURGERAMT_IDS, '')}"

        Termin.new(date, link)
      end
    end

    def download_latest_calendar
      @options.dry_run? ? Nokogiri.parse(File.read SAMPLES_PATH) :
                          Nokogiri.parse(Curl::Easy.perform(Termin::QUERY_URL).body_str)
    end
  end
end
