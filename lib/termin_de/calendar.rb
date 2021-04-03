# frozen_string_literal: true

require 'curb'
require 'nokogiri'
require 'time'

module TerminDe
  # burgeramt calendar entity
  class Calendar
    BURGERAMT_IDS = [
      # ALL '122210,122217,327316,122219,327312,122227,122231,327346,122238,122243,327348,122252,329742,122260,329745,122262,329748,122254,329751,122271,327278,122273,122277,327276,122280,327294,122282,327290,122284,327292,122291,327270,122285,327266,122286,327264,122296,327268,327262,325657,150230,329760,122301,327282,122297,327286,122294,327284,122312,329763,122304,327330,122311,327334,122309,327332,317869,324434,122281,327352,122279,122276,327324,122274,327326,122267,329766,122246,327318,122251,327320,327653,122257,327322,122208,122226'
      '122243', # Friedrichshain Frankfurter
      '122238', # Friedrichshain Schlesisches Tor
      '122260', # Lichtenberg Moellendorfstr
      '122262' # Lichtenberg TierparkCenter
    ]
    SAMPLES_PATH = File.expand_path('../../samples/calendar.html', __dir__)
    TERMIN_CSS_PATH = 'td.buchbar a'
    URL = 'https://service.berlin.de/terminvereinbarung/termin'

    attr_reader :booked_termin, :options

    def initialize(options)
      @options = options
      @booked_termin = Termin.new(
        date: options.before_date,
        service: options.service
      )
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
        Termin.new(
          date: Date.parse(time.to_s),
          link: url,
          service: @booked_termin.service
        )
      end
    end

    def url
      [
        URL + '/tag.php?termin=1',
        'dienstleisterlist=' + burgeramt_ids,
        'anliegen[]=' + @booked_termin.service,
        'herkunft=http%3A%2F%2Fservice.berlin.de%2Fdienstleistung%2F' + @booked_termin.service + '%2F'
      ].join('&')
    end

    def burgeramt_ids
      [options.burgeramt].join(',')
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
      curl.url = url
      curl.http_get
      Nokogiri.parse(curl.body_str)
    end
  end
end
