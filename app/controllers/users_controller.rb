class UsersController < ApplicationController
  before_action :set_user, only: %i[ show liked feed followers following discover ]

  def feed
    if current_user != @user
      redirect_back fallback_location: root_url, alert: "nice try"
    end
  end

  def discover
    if current_user != @user
      redirect_back fallback_location: root_url, alert: "nice try"
    end
  end

  private

    def set_user
      if params[:username]
        @user = User.find_by!(username: params.fetch(:username))
      else
        @user = current_user
      end
    end
end