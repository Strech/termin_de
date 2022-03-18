# frozen_string_literal: true

require 'spec_helper'

describe TerminDe::Calendar do
  # the sample calendar is used which returns 2020-08-31 as bookable
  describe '#earlier?' do
    let(:options) do
      TerminDe::Cli::Options.new(before_date, after_date, true, '12345')
    end

    subject { described_class.new(options).earlier? }

    context 'when the booked termin is within the time window' do
      let(:after_date)  { Date.new(2020, 8, 30) }
      let(:before_date) { Date.new(2020, 9,  1) }

      it { is_expected.to be_truthy }
    end

    context 'when the booked termin is before the time window' do
      let(:after_date)  { Date.new(2020, 9, 1) }
      let(:before_date) { Date.new(2020, 9, 2) }

      it { is_expected.to be_falsy }
    end

    context 'when the booked termin is after the time window' do
      let(:after_date)  { Date.new(2020, 8, 29) }
      let(:before_date) { Date.new(2020, 8, 30) }

      it { is_expected.to be_falsy }
    end

    context 'when the booked termin is equal to after date' do
      let(:after_date)  { Date.new(2020, 8, 31) }
      let(:before_date) { Date.new(2020, 9,  1) }

      it { is_expected.to be_falsy }
    end

    context 'when the booked termin is equal to before date' do
      let(:after_date)  { Date.new(2020, 8, 30) }
      let(:before_date) { Date.new(2020, 8, 31) }

      it { is_expected.to be_falsy }
    end
  end
end
