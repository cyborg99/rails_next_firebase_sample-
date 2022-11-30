# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resolvers::User do
  subject(:execute) { AppSchema.execute(query, context: { current_user: user }) }

  let(:user) { create(:user, email: 'test@example.com', uid: 'uid_xxx', user_name: 'テストユーザー', refresh_token: 'refresh_token_xxx') }
  let(:query) do
    <<~GRAPHQL
      query user {
        user {
          id
          email
          userName
          createdAt
          updatedAt
        }
      }
    GRAPHQL
  end
  let(:expected_value) do
    {
      'id' => user.id.to_s,
      'email' => user.email,
      'userName' => user.user_name,
      'createdAt' => anything,
      'updatedAt' => anything
    }
  end

  it { expect(execute['data']['user']).to match(expected_value) }
end
