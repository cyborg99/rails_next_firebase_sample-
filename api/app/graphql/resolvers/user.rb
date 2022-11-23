# frozen_string_literal: true

module Resolvers
  class User < GraphQL::Schema::Resolver
    type Types::UserType, null: false

    def resolve
      context[:current_user]
    end
  end
end
