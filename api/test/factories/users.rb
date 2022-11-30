# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:uid, 'uid_1')
    sequence(:refresh_token, 'refresh_token_1')
  end
end
