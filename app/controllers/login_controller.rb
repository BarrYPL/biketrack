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
            
            #get user last ride info
            session[:current_user_token] = @params['access_token']
            time_now_to_link = Time.now.to_i.to_s
            if Ride.where(athlete_id: @params['athlete']['id']).count > 0
                time_after = Ride.where(athlete_id: @params['athlete']['id']).order(timestamp: :desc).first[:timestamp]
                activities_request_url = "https://www.strava.com/api/v3/athlete/activities?before=#{time_now_to_link}&after=#{time_after}&page=1&per_page=5"
                response = Excon.get(activities_request_url, :headers => {'Authorization' => "Bearer #{@params['access_token']}"})
                response_rides = JSON.parse(response.body)
                unless response_rides.first.nil? 
                    add_ride_to_db(response_rides) 
                end
            else
                page = 1
                loop do
                    activities_paged_url = "https://www.strava.com/api/v3/athlete/activities?per_page=50&page=#{page}"
                    response = Excon.get(activities_paged_url, :headers => {'Authorization' => "Bearer #{@params['access_token']}"})
                    response_rides = JSON.parse(response.body)
                    if response_rides.count == 0
                        break
                    end
                    unless response_rides.first.nil? 
                        add_ride_to_db(response_rides) 
                    end 
                    page += 1
                end
            end
            @last_ride_info = Ride.where(athlete_id: @params['athlete']['id']).order(timestamp: :desc).first
            @last_ride = Hash.new()
            unless @last_ride_info.nil?
                @last_ride['name'] = @last_ride_info['name']
                @last_ride['timestamp'] = Time.at(@last_ride_info['timestamp']).strftime("%A, %B %d, %Y")
                @last_ride['distance'] = (@last_ride_info['distance'].to_f / 1000.0).round(2)
                @last_ride['moving_time'] = format_time(@last_ride_info['moving_time'])
                @last_ride['total_elevation_gain'] = (@last_ride_info['total_elevation_gain']).round(0) 
                @last_ride['average_speed'] = (@last_ride_info['average_speed'] * 3.6).round(2) 
                @last_ride['max_speed'] = (@last_ride_info['max_speed'] * 3.6).round(2)
            end
            @last_ride['name'] ||= "--"
            @last_ride['timestamp'] ||= "--"
            @last_ride['distance'] ||= "--" 
            @last_ride['moving_time'] ||= "--"
            @last_ride['total_elevation_gain'] ||= "--" 
            @last_ride['average_speed'] ||= "--" 
            @last_ride['max_speed'] ||= "--"

            #get max values
            if (Ride.where(athlete_id: @params['athlete']['id']).all.count > 0)
                @max_speed = (Ride.where(athlete_id: @params['athlete']['id']).order(max_speed: :desc).first[:max_speed] * 3.6).round(2) 
                @longest_ride = (Ride.where(athlete_id: @params['athlete']['id']).order(distance: :desc).first[:distance].to_f / 1000.0).round(2) 
                @max_total_elevation_gain = Ride.where(athlete_id: @params['athlete']['id']).order(total_elevation_gain: :desc).first[:total_elevation_gain] 
                @total_counted_kilometers = (Ride.where(athlete_id: @params['athlete']['id']).sum(:distance) / 1000.0).round(2)
                @total_rides = Ride.where(athlete_id: @params['athlete']['id']).count
            end
            @total_rides ||= "--"
            @max_speed ||= "--"
            @longest_ride ||= "--"
            @max_total_elevation_gain ||= "--"
            @total_counted_kilometers ||= "--"

            #get all bikes
            if (Ride.where(athlete_id: @params['athlete']['id']).all.count > 0)
                @unique_gear_ids = Ride.where(athlete_id: @params['athlete']['id']).where.not(gear_id: nil).distinct.pluck(:gear_id)
            else
                @unique_gear_ids = []
            end

            unless (@unique_gear_ids.empty?)
                @gears_array = []
                @unique_gear_ids.each do |gear|
                    gears_request_url = "https://www.strava.com/api/v3/gear/#{gear}"
                    response = Excon.get(gears_request_url, :headers => {'Authorization' => "Bearer #{@params['access_token']}"})
                    @gears_array << JSON.parse(response.body)
                end
            end
            
            @gears_array ||= "--"
        end
    end
    
    private

    def format_time(seconds)
        hours = seconds / 3600
        minutes = (seconds % 3600) / 60
        seconds = seconds % 60

        return "#{format('%02d', hours)}:#{format('%02d', minutes)}:#{format('%02d', seconds)}"
    end

    def add_ride_to_db(params_hash)
        params_hash.each do |ride_hash|
            unless Ride.exists?(ride_id: ride_hash['id'])
                Ride.create!(
                    name: ride_hash['name'],
                    distance: ride_hash['distance'],
                    athlete_id: ride_hash['athlete']['id'],
                    moving_time: ride_hash['moving_time'],
                    timestamp: Time.parse(ride_hash['start_date']).to_i,
                    gear_id: ride_hash['gear_id'],
                    average_speed: ride_hash['average_speed'],
                    max_speed: ride_hash['max_speed'],
                    total_elevation_gain: ride_hash['total_elevation_gain'],
                    ride_id: ride_hash['id']
                )
            end
        end
    end

end
