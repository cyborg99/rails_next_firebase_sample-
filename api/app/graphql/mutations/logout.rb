# frozen_string_literal: true

module Mutations
  class Logout < BaseMutation
    def resolve
      delete_session
    end
  end
end
