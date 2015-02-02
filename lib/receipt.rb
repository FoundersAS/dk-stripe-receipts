module StripeReceipts
  class Receipt
    def initialize params
      @attrs = params.fetch('data').fetch('object')
    end

    attr_reader :attrs

    def recipient
      attrs["receipt_email"]
    end

    def total
      attrs["amount"].to_f / 100.0
    end

    def vat
      total / 100 * 20
    end

    def send!

    end
  end
end
