# frozen_string_literal: true

require 'curb'
require 'nokogiri'
require 'time'

module TerminDe
  # burgeramt calendar entity
  class Calendar
    SAMPLES_PATH = File.expand_path('../../samples/calendar.html', __dir__)
    TERMIN_CSS_PATH = 'td.buchbar a'

    attr_reader :booked_termin

    def initialize(options)
      @options = options
      @booked_termin = Termin.new(date: options.before_date)
    end

    def earlier?
      !earlier_termin.link.nil? && earlier_termin.date != booked_termin.date
    end

    def earlier_termin
      @earlier_termin ||= (available_termins | [booked_termin]).min_by(&:date)
    end

    def available_termins
      bookable_termins = download_latest_calendar.css(TERMIN_CSS_PATH)
      bookable_termins.map do |link|
        time = Time.at(link.attr(:href).match(/\d+/)[0].to_i)
        Termin.new(date: Date.parse(time.to_s), link: Termin::QUERY_URL)
      end
    end

    # Downloading the termin calendar
    #
    # it is important to enable cookies, because the identification of
    # a user request is handled by the cookie "Zmsappointment"
    # also a redirect is performed, because the first request does not
    # contain the cookie
    def download_latest_calendar
      return Nokogiri.parse(File.read(SAMPLES_PATH)) if @options.dry_run?

      curl = Curl::Easy.new
      curl.enable_cookies = true
      curl.follow_location = true
      curl.url = Termin::QUERY_URL
      curl.http_get
      Nokogiri.parse(curl.body_str)
    end
  end
end
