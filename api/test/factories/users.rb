FactoryBot.define do
  factory :user do
    sequence(:uid, 'uid_1')
    sequence(:id_token, 'id_token_1')
    sequence(:refresh_token, 'refresh_token_1')
  end
end
