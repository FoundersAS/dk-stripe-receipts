module StripeReceipts
  def self.root
    ROOT
  end
  def self.env
    (ENV["RACK_ENV"] || :development).to_sym
  end
end

require 'bundler/setup'
Bundler.require :default, StripeReceipts.env
Dotenv.load unless StripeReceipts.env == :production
require 'json'

