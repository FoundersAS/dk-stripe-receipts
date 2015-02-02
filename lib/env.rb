require 'pathname'

module StripeReceipts
  def self.root
    Pathname.new File.join(File.expand_path(File.dirname __FILE__), '..')
  end
  def self.env
    (ENV["RACK_ENV"] || :development).to_sym
  end
end

$:.push StripeReceipts.root.to_s
require 'bundler/setup'
Bundler.require :default, StripeReceipts.env
Dotenv.load unless StripeReceipts.env == :production

module StripeReceipts
  def self.db
    Sequel.connect ENV["DATABASE_URL"] ||
      "postgres://localhost/stripe_receipts_#{StripeReceipts.env}"
  end
end


Pony.options = {
  from: 'nobody@founders.as',
  via: :smtp,
  via_options: {
    :address   => "smtp.mandrillapp.com",
    :port      => 587,
    :enable_starttls_auto => true,
    :user_name => ENV["MANDRILL_USER"],
    :password  => ENV["MANDRILL_PASS"],
    :authentication => 'login',
    :domain => ENV["HOST"]
  }
}

Sequel::Model.db = StripeReceipts.db

