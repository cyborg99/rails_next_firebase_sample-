# frozen_string_literal: true

class ApplicationController < ActionController::API
  include FirebaseAuth
  include ActionController::HttpAuthentication::Token::ControllerMethods

  private

  def current_user
    authenticate_with_http_token { |token| @current_user ||= find_form_id_token!(token) if token }
  end
end
