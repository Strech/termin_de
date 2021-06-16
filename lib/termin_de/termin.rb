# frozen_string_literal: true

module TerminDe
  # simple termin object to hold date, link and the service
  class Termin
    attr_reader :date
    attr_reader :link
    attr_reader :service

    def initialize(date:, link: '', service:)
      @date = date
      @link = link
      @service = service
    end

    def to_h
      {link: @link, date: @date}
    end
  end
end
