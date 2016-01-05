require 'spec_helper'

describe TerminDe::Calendar do

  describe '#has_earlier?' do
    let(:options) { TerminDe::Cli::Options.new(booked_termin_date, true) }

    subject { described_class.new(options).has_earlier? }

    context 'when the booked termin is later than the available termins' do
      let(:booked_termin_date) { Date.new(2015, 11, 10) }

      it { is_expected.to be_truthy }
    end

    context 'when the booked termin is earlier than the available termins' do
      let(:booked_termin_date) { Date.new(2015, 11, 4) }

      it { is_expected.to be_falsy }
    end

    context 'when the booked termin is equal than the earlier available termin' do
      let(:booked_termin_date) { Date.new(2015, 11, 5) }

      it { is_expected.to be_falsy }
    end
  end

end
