class LoginController < ApplicationController
    def redirect_oauth
        redirect_to 'http://www.strava.com/oauth/authorize?client_id=113042&response_type=code&redirect_uri=https://biketrack.pro/oauth-callback&approval_prompt=auto&scope=read,profile:read_all,activity:read_all', allow_other_host: true
    end

    def authenticate
        @params = params
    end
end
