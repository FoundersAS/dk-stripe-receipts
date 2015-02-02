require 'spec_helper'
require 'rack/test'
require './lib/application'

module StripeReceipts
  RSpec.describe App do
    include Rack::Test::Methods
    include WebMock::API

    def app
      @app ||= App.new
    end

    def session
      last_request.env["rack.session"]
    end

    describe "GET /" do
      subject { get '/' }
      it { should be_ok }
    end

    describe "GET /authorize" do
      subject { get '/authorize' }
      it { should be_redirect }
    end

    describe "GET /oauth/callback" do
      let(:code) { 'CODE' }
      let(:token) { 'TOKEN' }
      before do
        stub_request(:post, "https://connect.stripe.com/oauth/token").with(:body => {
          "client_id"=>ENV["STRIPE_CLIENT_ID"],
          "client_secret"=>ENV["STRIPE_API_KEY"],
          "code"=> code,
          "grant_type"=>"authorization_code",
          "params"=>{"scope"=>"read_only"}
        }).to_return({
          headers: { "Content-Type": 'application/json' },
          body: JSON.dump({
            "token_type": "bearer",
            "access_token": token
          })
        })
      end
      subject { get '/oauth/callback', code: code }
      it "creates a user" do
        expect(StripeReceipts::User).to receive(:create)
          .with(access_token: token) { double id: 1 }
        subject
      end
      it "sets session" do
        subject
        expect(session['user_id']).to eq User.last.id
      end
      it { should be_redirect }
    end

    describe "POST /hook" do
      subject { post '/hook', mock_request }
      it { should be_ok }
      it "should make an event and process it" do
        receipt = double send!: true
        expect(Receipt).to receive(:new) { receipt }
        subject
        expect(receipt).to have_received(:send!)
      end
    end
  end
end

