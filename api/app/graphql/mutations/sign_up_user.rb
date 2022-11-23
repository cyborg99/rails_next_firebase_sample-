# frozen_string_literal: true

module Mutations
  class SignUpUser < BaseMutation
    include FirebaseAuth
    field :user, Types::UserType, null: false

    argument :token, String, required: true

    def resolve(token:)
      @token = token

      { user: User.find_by(uid:) || User.create!(user_name:, email:, uid:) }
    end
  end
end
