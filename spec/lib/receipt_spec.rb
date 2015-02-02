require 'spec_helper'
require 'receipt'

module StripeReceipts
  RSpec.describe Receipt do

    subject { Receipt.new(mock_request) }

    it "has a recipient" do
      expect(subject.recipient).to eq "mikkelmalmberg@me.com"
    end

    it "has a total" do
      expect(subject.total).to eq 30.00
    end

    it "has vat" do
      expect(subject.vat).to eq 6.0
    end

    describe "#send!" do
      # it "has a recepient" do
      #   expect(sub
      # end
    end

  end
end
