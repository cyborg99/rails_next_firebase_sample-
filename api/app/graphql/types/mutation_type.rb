# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :sign_up_user, mutation: Mutations::SignUpUser
    field :sign_in_user, mutation: Mutations::SignInUser
    field :logout, mutation: Mutations::Logout
  end
end
