require 'yaml'
require './lib/env'
require './lib/user'
require './lib/receipt'

module StripeReceipts
  class App < Sinatra::Base
    use Rack::Session::Cookie,
      key: 'rack.session',
      expire_after: 60 * 60 * 24 * 365,
      secret: '_session_key_asdkjaskkjsdczxcjkzxjkjksereoioiqpqpsanzxnzxczjkksdf'

    configure do
      enable :logging, :dump_errors, :raise_errors

      set :api_key, ENV["STRIPE_API_KEY"]
      set :client_id, ENV["STRIPE_CLIENT_ID"]
      set :scope, {scope: 'read_only'}
      set :client, OAuth2::Client.new(settings.client_id, settings.api_key, {
        site: 'https://connect.stripe.com',
        authorize_url: '/oauth/authorize',
        token_url: '/oauth/token'
      })
    end

    helpers do
      def current_user
        @current_user ||= User[session[:user_id]]
      end
    end

    get '/' do
      <<-HTML
      <a href='/authorize'>Authorize</a><br>
      #{current_user && current_user.access_token|| "no user"}<br>
      HTML
    end

    get '/authorize' do
      redirect settings.client.auth_code.authorize_url(params: settings.scope)
    end

    get '/oauth/callback' do
      token = settings.client.auth_code.get_token(params[:code], {
        params: settings.scope
      }).token

      user = User.create(access_token: token)
      session[:user_id] = user.id

      redirect '/'
    end

    post '/hook' do
      case params["type"]
      when "charge.succeeded"
        Receipt.new(params).send!
      end

      "ok"
    end
  end
end
