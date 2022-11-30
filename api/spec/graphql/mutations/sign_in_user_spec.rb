# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::SignInUser do
  subject(:execute) { AppSchema.execute(query, variables:, context: { session: {} }) }

  include_context 'with FirebaseAuth setup'
  include_context 'with FirebaseAuth 有効な公開鍵がキャッシュに保存されている'

  let(:id_token) { 'id_token_xxx' }
  let(:uid) { 'uid_xxx' }
  let(:email) { 'test@example.com' }
  let(:username) { 'テストユーザー' }
  let(:refresh_token) { 'refresh_token_xxx' }
  let(:variables) { { input: { idToken: id_token, refreshToken: refresh_token } } }
  let!(:user) { create(:user, email:, uid:, user_name: username, refresh_token:) }
  let(:query) do
    <<~GRAPHQL
      mutation signInUser($input: SignInUserInput!) {
        signInUser(input: $input) {
          __typename
          user {
            id
            email
          }
        }
      }
    GRAPHQL
  end
  let(:expected_value) do
    {
      'id' => user.id.to_s,
      'email' => user.email
    }
  end

  it { expect(execute['data']['signInUser']['user']).to match(expected_value) }
end
