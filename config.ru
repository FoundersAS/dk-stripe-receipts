$:.push File.expand_path(File.dirname __FILE__)
require "lib/application"
run StripeReceipts::App.new
