class LoginController < ApplicationController
    def redirect_oauth
        redirect_to 'https://www.strava.com/oauth/authorize?client_id=113042&response_type=code&redirect_uri=https://biketrack.pro/oauth-callback&approval_prompt=auto&scope=read,profile:read_all,activity:read_all', allow_other_host: true
    end

    def authenticate
        strava_key_handler = "https://www.strava.com/oauth/token"
        response = Excon.post(strava_key_handler, body => '{:client_id => "113042", :client_secret => "c9fb38720c6838d9f42ef6bace73ca694f948eaa", :code => params[:code], :grant_type => "authorization_code"}')
        puts response.body
        @params = JSON.parse(response.body)
    end
end
