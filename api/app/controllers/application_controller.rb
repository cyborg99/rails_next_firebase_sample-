# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def current_user
    @current_user ||= User.find_and_refresh_token(request.headers[:Authorization])
  end
end
