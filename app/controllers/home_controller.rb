class HomeController < ApplicationController
    unless session[:current_user_token].nil?
        redirect_to after_login
    end
end
