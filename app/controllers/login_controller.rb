class LoginController < ApplicationController
    def redirect_oauth
        redirect_to 'http://www.strava.com/oauth/authorize?client_id=113042&response_type=code&redirect_uri=https://biketrack.pro/oauth-callback&approval_prompt=auto&scope=read,profile:read_all,activity:read_all', allow_other_host: true
    end

    def authenticate
        strava_key_handler = "https://www.strava.com/oauth/token"
        response = RestClient.post(strava_key_handler, {:client_id => '113042', :client_secret => '0935331f476fe183e93f1d8ab5281a491dabf9be', :code => params[:code], :grant_type => 'authorization_code'})        
        @params = JSON.parse(response.body)
        if UserInfo.exists?(athlete_id: @params[:athlete[:id]])
            @txt = "We know him."
        else
            @txt = "Adding to db."
        end
    end
end
