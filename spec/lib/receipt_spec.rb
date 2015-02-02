require 'spec_helper'
require 'receipt'

module StripeReceipts
  RSpec.describe Receipt do

    subject { Receipt.new(mock_request) }

    it "has a recipient" do
      expect(subject.recipient_email).to eq "mikkelmalmberg@me.com"
    end

    it "has a subject" do
      expect(subject.subject).to eq "Din kvittering for Mandehader?"
    end

    it "has a description" do
      expect(subject.description).to eq "Mandehader?"
    end

    it "has a total" do
      expect(subject.total).to eq 30.00
    end

    it "has vat" do
      expect(subject.vat).to eq 6.0
    end

    it "has a html body" do
      expect(subject.html_body).to match "Mandehader?"
    end

    describe "#send!" do
      it "sends an email" do
        expect(Pony).to receive(:mail).with({
          to: subject.recipient_email,
          subject: subject.subject,
          html_body: subject.html_body
        }) { true }
        subject.send!
      end
    end

  end
end
