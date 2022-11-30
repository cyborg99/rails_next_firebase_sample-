# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FirebaseAuth do
  let(:test_class) do
    Class.new do
      include FirebaseAuth
      attr_accessor :session

      def initialize
        @session = { id_token: 'id_token_xxx', refresh_token: 'refresh_token_xxx' }
      end
    end
  end
  let(:concern) { test_class.new }

  describe '#find_form_id_token' do
    subject(:execute) { concern.find_form_id_token! }

    let(:uid) { 'uid_xxx' }
    let(:email) { 'test@example.com' }
    let(:username) { 'テストユーザー' }
    let(:id_token) { 'id_token_xxx' }
    let(:refresh_token) { 'refresh_token_xxx' }
    let!(:user) { create(:user, uid:, email:, user_name: username, refresh_token:) }

    context 'with 有効期限内のid_token' do
      include_context 'with FirebaseAuth 有効な公開鍵がキャッシュに保存されている'
      it do
        expect { execute }.not_to(change { concern.session[:id_token] })
        expect(execute).to eq(user)
      end
    end

    context 'with 有効期限切れのIDトークン' do
      let!(:user) { create(:user, uid:, email:, user_name: username, refresh_token:) }

      before do
        allow(JWT).to receive(:decode).with(id_token, nil, true, FirebaseAuth::OPTIONS).and_raise(JWT::ExpiredSignature)
      end

      context 'with 有効なreflesh_token' do
        before do
          allow(Net::HTTP).to receive(:post_form).with(
            URI.parse('https://securetoken.googleapis.com/v1/token?key=firebase_api_key_xxx'),
            grant_type: 'refresh_token', refresh_token: 'refresh_token_xxx'
          ).and_return(OpenStruct.new(code: '200',
                                      body: { user_id: uid, refresh_token: 'new_refresh_token_xxx',
                                              id_token: 'new_id_token_xxx' }.to_json))
        end

        it do
          expect { execute }.to change { concern.session[:id_token] }.from('id_token_xxx').to('new_id_token_xxx')
                                                                     .and change {
                                                                            user.reload.refresh_token
                                                                          }.from('refresh_token_xxx').to('new_refresh_token_xxx')
          expect(execute).to eq(user.reload)
        end

        context 'with userが見つからない場合' do
          let!(:user) { create(:user, uid: 'uid_not_found') }

          it { expect { execute }.to raise_error(StandardError) }
        end
      end

      context 'with 不正なreflesh_token' do
        before do
          allow(Net::HTTP).to receive(:post_form).with(
            URI.parse('https://securetoken.googleapis.com/v1/token?key=firebase_api_key_xxx'),
            grant_type: 'refresh_token', refresh_token: 'refresh_token_xxx'
          ).and_return(OpenStruct.new(code: '400', body: { error: { message: 'TOKEN_EXPIRED' } }.to_json))
        end

        it { expect { execute }.to raise_error('TOKEN_EXPIRED') }
      end
    end
  end
end
