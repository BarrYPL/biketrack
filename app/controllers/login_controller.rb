class LoginController < ApplicationController
    def redirect_oauth
        redirect_to 'https://www.strava.com/oauth/authorize?client_id=113042&response_type=code&redirect_uri=https://biketrack.pro/oauth-callback&approval_prompt=auto&scope=read,profile:read_all,activity:read_all', allow_other_host: true
    end

    def authenticate
        strava_key_handler = "https://www.strava.com/oauth/token"
        response = Excon.post(strava_key_handler, :body => URI.encode_www_form(:client_id => '113042', :client_secret => 'c9fb38720c6838d9f42ef6bace73ca694f948eaa', :code => params[:code], :grant_type => 'authorization_code'))
        @params = JSON.parse(response.body)
        if (@params.has_key?("message"))
            redirect_to homepage_url
        else
            if UserInfo.exists?(athlete_id: @params["athlete"]["id"])
                @txt = "Hello again "
                @curr_user_name = @params["athlete"]["firstname"]
                @athlete_city = @params["athlete"]["city"]
            else
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
                @txt = "Welcome "
            end
            session[:current_user_token] = @params['access_token']
            time_now_to_link = Time.now.to_i.to_s
            #if Rides.where(athlete_id: @params['athlete']['id'])
            activities_request_url = "https://www.strava.com/api/v3/athlete/activities?before=#{time_now_to_link}&after=0&page=1&per_page=30"
            response = Excon.get(activities_request_url, :headers => {'Authorization' => "Bearer #{@params['access_token']}"})
            response_rides = JSON.parse(response.body)
            @last_ride = response_rides.first
            @last_ride['distance'] = (@last_ride['distance'].to_f / 1000.0).round(2)
            @last_ride['moving_time'] = format_time(@last_ride['moving_time'])
            @last_ride['total_elevation_gain'] = (@last_ride['total_elevation_gain']).round(0)
            @last_ride['average_speed'] = (@last_ride['average_speed'] * 3.6).round(2)
            @last_ride['max_speed'] = (@last_ride['max_speed'] * 3.6).round(2)
        end
    end

    private

    def format_time(seconds)
        hours = seconds / 3600
        minutes = (seconds % 3600) / 60
        seconds = seconds % 60
    
        return "#{format('%02d', hours)}:#{format('%02d', minutes)}:#{format('%02d', seconds)}"
    end
end
