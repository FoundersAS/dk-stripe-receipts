require 'rspec'

ENV["RACK_ENV"] = "test"
require './lib/env'

require "backtrace_shortener"
BacktraceShortener.monkey_patch_the_exception_class!
require 'webmock'
require 'database_cleaner'

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  def mock_request
    @mock_request ||= JSON.parse File.read(
      StripeReceipts.root.join 'spec/fixtures/charge_succeeded.json')
  end

end

