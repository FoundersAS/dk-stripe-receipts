require 'pathname'

module StripeReceipts
  def self.root
    Pathname.new File.expand_path(File.dirname __FILE__)
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
    Sequel.connect ENV["DATABASE_URL"]
  end
end

Sequel::Model.db = StripeReceipts.db

