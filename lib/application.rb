require 'lib/env'
require 'yaml'

module StripeReceipts
  class App < Sinatra::Base

    configure do
      set :sessions, true

      set :api_key, ENV["STRIPE_API_KEY"]
      set :client_id, ENV["STRIPE_CLIENT_ID"]
      set :scope, {scope: 'read_only'}
      set :client, OAuth2::Client.new(settings.client_id, settings.api_key, {
        site: 'https://connect.stripe.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      })
    end

    get '/' do
      "<a href='/authorize'>Authorize</a>"
    end

    get '/authorize' do
      redirect settings.client.auth_code.authorize_url(params: settings.scope)
    end

    get '/oauth/callback' do
      content_type 'text/plain'
      resp = settings.client.auth_code.get_token(params[:code], {
        params: settings.scope
      })

      token = resp.token
      "token:#{token}"
    end
  end
end
