class HomeController < ApplicationController
    unless session.empty?
        redirect_to after_login
    end
end
