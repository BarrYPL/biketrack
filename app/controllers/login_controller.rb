class LoginController < ApplicationController
    def redirect_oauth
        client = OAuth2::Client.new('113042', '0935331f476fe183e93f1d8ab5281a491dabf9be', site: 'http://www.strava.com/oauth/authorize')
        client.auth_code.authorize_url(redirect_uri: 'https://www.biketrack.pro/authenticate')
        #redirect_to 'http://www.strava.com/oauth/authorize?client_id=113042&response_type=code&redirect_uri=http://localhost/exchange_token&approval_prompt=auto&scope=read,profile:read_all,activity:read_all', allow_other_host: true
    end

    def authenticate
        puts params.inspect
    end
end
