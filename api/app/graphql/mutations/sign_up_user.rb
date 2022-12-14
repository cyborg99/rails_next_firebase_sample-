# frozen_string_literal: true

module Mutations
  class SignUpUser < BaseMutation
    field :user, Types::UserType, null: false

    argument :id_token, String, required: true
    argument :refresh_token, String, required: true

    def resolve(id_token:, refresh_token:)
      setting_session(id_token, refresh_token)
      { user: create_form_id_token! }
    end
  end
end
