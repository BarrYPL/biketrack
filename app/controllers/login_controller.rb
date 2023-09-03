class LoginController < ApplicationController
    def redirect_oauth
        redirect_to 'http://www.strava.com/oauth/authorize?client_id=113042&response_type=code&redirect_uri=https://biketrack.pro/oauth-callback&approval_prompt=auto&scope=read,profile:read_all,activity:read_all', allow_other_host: true
    end

    def authenticate
        strava_key_handler = "https://www.strava.com/oauth/token"
        response = RestClient.post(strava_key_handler, {:client_id => '113042', :client_secret => '0935331f476fe183e93f1d8ab5281a491dabf9be', :code => params[:code], :grant_type => 'authorization_code'})        
        @params = JSON.parse(response.body)
        if UserInfo.exists?(athlete_id: @params["athlete"]["id"])
            @txt = "We know him."
        else
            UserInfo.Create!(
                token_type: hash['token_type'],
                expires_at: hash['expires_at'],
                expires_in: hash['expires_in'],
                refresh_token: hash['refresh_token'],
                access_token: hash['access_token'],
                athlete_id: hash['athlete']['id'],
                athlete_username: hash['athlete']['username'],
                athlete_resource_state: hash['athlete']['resource_state'],
                athlete_firstname: hash['athlete']['firstname'],
                athlete_lastname: hash['athlete']['lastname'],
                athlete_bio: hash['athlete']['bio'],
                athlete_city: hash['athlete']['city'],
                athlete_state: hash['athlete']['state'],
                athlete_country: hash['athlete']['country'],
                athlete_sex: hash['athlete']['sex'],
                athlete_premium: hash['athlete']['premium'],
                athlete_summit: hash['athlete']['summit'],
                athlete_created_at: DateTime.parse(hash['athlete']['created_at']),
                athlete_updated_at: DateTime.parse(hash['athlete']['updated_at']),
                athlete_badge_type_id: hash['athlete']['badge_type_id'],
                athlete_weight: hash['athlete']['weight'],
                athlete_profile_medium: hash['athlete']['profile_medium'],
                athlete_profile: hash['athlete']['profile'],
                athlete_friend_id: hash['athlete']['friend'],
                athlete_follower_id: hash['athlete']['follower']
            )
            @txt = "Added to db."
        end
    end
end
