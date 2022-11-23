# frozen_string_literal: true

class User < ApplicationRecord
  class << self
    def find_and_refresh_token(refresh_token)
      return if refresh_token.blank?

      responce = Net::HTTP.post_form(
        URI.parse("https://securetoken.googleapis.com/v1/token?key=#{ENV.fetch('FIREBASE_APY_KEY')}"),
        grant_type: 'refresh_token', refresh_token:
      )
      body = JSON.parse(responce.body)
      return find_by!(uid: body['user_id']) if responce.code == '200'

      raise StandardError, body['error']['message']
    end
  end
end
