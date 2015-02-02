$:.push File.expand_path(File.dirname __FILE__)
require 'lib/env'
require "lib/application"
run StripeReceipts::App.new
