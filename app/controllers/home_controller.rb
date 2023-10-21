class HomeController < ApplicationController
    def index
        if UserInfo.find_by?(athlete_id: session[:current_user_id])
            redirect_to user_profile_url
        end
    end
end
