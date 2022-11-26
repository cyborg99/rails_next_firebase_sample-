# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::SignUpUser do
  subject(:execute) { AppSchema.execute(query, variables:) }

  let(:id_token) { 'id_token_xxx' }
  let(:refresh_token) { 'refresh_token_xxx' }
  let(:username) { 'テストユーザー' }
  let(:email) { 'test@example.com' }
  let(:uid) { 'uid_xxxx' }
  let(:variables) { { input: { idToken: id_token, refreshToken: refresh_token } } }
  let(:query) do
    <<~GRAPHQL
      mutation($input: SignUpUserInput!) {
        signUpUser(input: $input) {
          user {
            id
            email
            userName
            refreshToken
            idToken
            createdAt
            updatedAt
          }
        }
      }
    GRAPHQL
  end
  let(:expected_value) do
    {

      'id' => User.last.id.to_s,
      'email' => email,
      'userName' => username,
      'refreshToken' => refresh_token,
      'idToken' => id_token,
      'createdAt' => anything,
      'updatedAt' => anything
    }
  end

  shared_examples 'Mutations::SignUpUser' do
    it do
      expect { execute }.to change { User.find_by(uid:) }.from(be_falsey).to(be_truthy)
      expect(execute['data']['signUpUser']['user']).to match(expected_value)
    end

    context 'with exists User' do
      let(:email) { nil }
      let(:username) { nil }

      before do
        create(:user, uid:)
      end

      it do
        expect { execute }.to raise_error(ActiveRecord::RecordNotUnique)
          .and not_change(User, :count)
      end
    end
  end

  context 'with 有効な公開鍵がキャッシュに保存されている' do
    include_context 'with FirebaseAuth 有効な公開鍵がキャッシュに保存されている'
    it_behaves_like 'Mutations::SignUpUser'
  end

  context 'with 有効な公開鍵がキャッシュに保存されていない' do
    include_context 'with FirebaseAuth 有効な公開鍵がキャッシュに保存されていない'
    it_behaves_like 'Mutations::SignUpUser'
  end

  context 'when 認証日が未来日' do
    include_context 'with FirebaseAuth 有効な公開鍵がキャッシュに保存されている', auth_time: 1.hour.from_now
    it do
      expect { execute }.to raise_error('Invalid auth_time')
        .and not_change(User, :count)
    end
  end

  context 'with payload から sub が取得できない' do
    let(:uid) { '' }

    include_context 'with FirebaseAuth 有効な公開鍵がキャッシュに保存されている'
    it do
      expect { execute }.to raise_error('Invalid sub')
        .and not_change(User, :count)
    end
  end
end
