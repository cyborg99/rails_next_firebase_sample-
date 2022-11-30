# frozen_string_literal: true

class ApplicationController < ActionController::API
  include FirebaseAuth

  private

  def current_user
    @current_user ||= find_form_id_token!
  end
end
