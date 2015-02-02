module StripeReceipts
  class Receipt
    def initialize params
      @attrs = params.fetch('data').fetch('object')
    end

    attr_reader :attrs

    def recipient_email
      attrs["receipt_email"]
    end

    def subject
      "Din kvittering for #{attrs["description"]}"
    end

    def description
      attrs["description"]
    end

    def total
      attrs["amount"].to_f / 100.0
    end

    def vat
      total / 100 * 20
    end

    def html_body
      template('charge_succeeded.erb').render(self, attrs_for_body)
    end

    def send!
      Pony.mail(to: recipient_email, subject: subject, html_body: html_body)
    end

    private

    def attrs_for_body
      %w{description total vat}.inject({}) do |hsh, attr|
        hsh.merge attr => send(attr.to_sym)
      end
    end

    def template filename
      Tilt.new StripeReceipts.root.join("views/emails/#{filename}").to_s
    end
  end
end
