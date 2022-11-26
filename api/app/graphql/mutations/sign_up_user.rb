# frozen_string_literal: true

module Mutations
  class SignUpUser < BaseMutation
    include FirebaseAuth
    field :user, Types::UserType, null: false

    argument :id_token, String, required: true
    argument :refresh_token, String, required: true

    def resolve(id_token:, refresh_token:)
      { user: create_form_id_token!(id_token, refresh_token) }
    end
  end
end
