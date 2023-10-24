class LoginController < ApplicationController
    def redirect_oauth
        @stored_client_id = Rails.application.config_for(:configuration)['stored_api_key']
        puts @stored_api_key
        redirect_to "https://www.strava.com/oauth/authorize?client_id=#{@stored_client_id}&response_type=code&redirect_uri=https://biketrack.pro/oauth-callback&approval_prompt=auto&scope=read,profile:read_all,activity:read_all", allow_other_host: true
    end

    def authenticate
        strava_key_handler = "https://www.strava.com/oauth/token"
        response = Excon.post(strava_key_handler, :body => URI.encode_www_form(:client_id => stored_client_id, :client_secret => stored_client_secret, :code => params[:code], :grant_type => 'authorization_code'))
        @params = JSON.parse(response.body)
        puts @params.body
        if (@params.has_key?("message"))
            redirect_to homepage_url
        else
            unless UserInfo.exists?(athlete_id: @params["athlete"]["id"])
                UserInfo.create!(
                    token_type: @params['token_type'],
                    expires_at: @params['expires_at'],
                    expires_in: @params['expires_in'],
                    refresh_token: @params['refresh_token'],
                    access_token: @params['access_token'],
                    athlete_id: @params['athlete']['id'],
                    athlete_username: @params['athlete']['username'],
                    athlete_resource_state: @params['athlete']['resource_state'],
                    athlete_firstname: @params['athlete']['firstname'],
                    athlete_lastname: @params['athlete']['lastname'],
                    athlete_bio: @params['athlete']['bio'],
                    athlete_city: @params['athlete']['city'],
                    athlete_state: @params['athlete']['state'],
                    athlete_country: @params['athlete']['country'],
                    athlete_sex: @params['athlete']['sex'],
                    athlete_premium: @params['athlete']['premium'],
                    athlete_summit: @params['athlete']['summit'],
                    athlete_created_at: DateTime.parse(@params['athlete']['created_at']),
                    athlete_updated_at: DateTime.parse(@params['athlete']['updated_at']),
                    athlete_badge_type_id: @params['athlete']['badge_type_id'],
                    athlete_weight: @params['athlete']['weight'],
                    athlete_profile_medium: @params['athlete']['profile_medium'],
                    athlete_profile: @params['athlete']['profile'],
                    athlete_friend_id: @params['athlete']['friend'],
                    athlete_follower_id: @params['athlete']['follower']
                )
                @curr_user_name = @params['athlete']['firstname']
            end
            session[:current_user_token] = @params['access_token']
            session[:current_user_id] = @params["athlete"]["id"]
            redirect_to user_profile_url
        end
    end
end
