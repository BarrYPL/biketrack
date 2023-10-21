class UserProfileController < ApplicationController
    def index
        if UserInfo.exists?(athlete_id: session[:current_user_id])
            @user = UserInfo.find_by(athlete_id: session[:current_user_id])

            #get user last ride info
            time_now_to_link = Time.now.to_i.to_s
            if Ride.where(athlete_id: session[:current_user_id]).count > 0
                time_after = Ride.where(athlete_id: session[:current_user_id]).order(timestamp: :desc).first[:timestamp]
                activities_request_url = "https://www.strava.com/api/v3/athlete/activities?before=#{time_now_to_link}&after=#{time_after}&page=1&per_page=5"
                response = Excon.get(activities_request_url, :headers => {'Authorization' => "Bearer #{session[:current_user_token]}"})
                response_rides = JSON.parse(response.body)
                unless response_rides.first.nil? 
                    add_ride_to_db(response_rides) 
                end
            else
                page = 1
                loop do
                    activities_paged_url = "https://www.strava.com/api/v3/athlete/activities?per_page=50&page=#{page}"
                    response = Excon.get(activities_paged_url, :headers => {'Authorization' => "Bearer #{session[:current_user_token]}"})
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
            @last_ride_info = Ride.where(athlete_id: session[:current_user_id]).order(timestamp: :desc).first
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
            if (Ride.where(athlete_id: session[:current_user_id]).all.count > 0)
                @max_speed = (Ride.where(athlete_id: session[:current_user_id]).order(max_speed: :desc).first[:max_speed] * 3.6).round(2) 
                @longest_ride = (Ride.where(athlete_id: session[:current_user_id]).order(distance: :desc).first[:distance].to_f / 1000.0).round(2) 
                @max_total_elevation_gain = Ride.where(athlete_id: session[:current_user_id]).order(total_elevation_gain: :desc).first[:total_elevation_gain] 
                @total_counted_kilometers = (Ride.where(athlete_id: session[:current_user_id]).sum(:distance) / 1000.0).round(2)
                @total_rides = Ride.where(athlete_id: session[:current_user_id]).count
            end
            @total_rides ||= "--"
            @max_speed ||= "--"
            @longest_ride ||= "--"
            @max_total_elevation_gain ||= "--"
            @total_counted_kilometers ||= "--"

            #get all bikes
            if (Ride.where(athlete_id: session[:current_user_id]).all.count > 0)
                @unique_gear_ids = Ride.where(athlete_id: session[:current_user_id]).where.not(gear_id: nil).distinct.pluck(:gear_id)
            else
                @unique_gear_ids = []
            end

            unless (@unique_gear_ids.empty?)
                @gears_array = []
                @unique_gear_ids.each do |gear|
                    gears_request_url = "https://www.strava.com/api/v3/gear/#{gear}"
                    response = Excon.get(gears_request_url, :headers => {'Authorization' => "Bearer #{session[:current_user_token]}"})
                    @gears_array << JSON.parse(response.body)
                end
            end
            
            #if user does not have any data fill everything with "--".
            @gears_array ||= "--"
        else
            redirect_to homepage_url
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
