# frozen_string_literal: true

class User < ApplicationRecord
  before_destroy :delete_from_firebase

  private

  def delete_from_firebase
    responce = Net::HTTP.post_form(
      URI.parse("https://identitytoolkit.googleapis.com/v1/accounts:delete?key=#{ENV.fetch('FIREBASE_APY_KEY')}"),
      idToken: id_token
    )
    body = JSON.parse(responce.body)
    raise StandardError, body['error']['message'] unless responce.code == '200'
  end
end
