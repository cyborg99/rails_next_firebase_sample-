# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '#find_and_refresh_token' do
    subject(:execute) { described_class.find_and_refresh_token(refresh_token) }

    let!(:user) { create(:user, uid: 'uid_xxx') }
    let(:refresh_token) { 'refresh_token_xxx' }

    context 'with 有効なreflesh_token' do
      before do
        allow(Net::HTTP).to receive(:post_form).with(
          URI.parse('https://securetoken.googleapis.com/v1/token?key=firebase_api_key_xxx'),
          grant_type: 'refresh_token', refresh_token: 'refresh_token_xxx'
        ).and_return(OpenStruct.new(code: '200', body: { user_id: 'uid_xxx' }.to_json))
      end

      it { is_expected.to eq(user) }

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

    context 'with reflesh_tokenがnil' do
      let(:refresh_token) { nil }

      it { is_expected.to be_nil }
    end
  end
end
