# frozen_string_literal: true

require 'spec_helper'

describe TerminDe::Calendar do
  # the sample calendar is used which returns 2020-09-01 as bookable
  describe '#earlier?' do
    let(:options) do
      TerminDe::Cli::Options.new(booked_termin_date, true, '12345')
    end

    subject { described_class.new(options).earlier? }

    context 'when the booked termin is later than the available termins' do
      let(:booked_termin_date) { Date.new(2020, 9, 2) }

      it { is_expected.to be_truthy }
    end

    context 'when the booked termin is earlier than the available termins' do
      let(:booked_termin_date) { Date.new(2020, 8, 31) }

      it { is_expected.to be_falsy }
    end

    context 'when the booked termin is equal than the earlier available termin' do
      let(:booked_termin_date) { Date.new(2020, 9, 1) }

      it { is_expected.to be_falsy }
    end
  end
end
