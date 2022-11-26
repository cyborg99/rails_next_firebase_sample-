# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe '#before_destroy' do
    let(:user) { create(:user) }

    it do
      allow(Net::HTTP).to receive(:post_form)
        .with(URI.parse('https://identitytoolkit.googleapis.com/v1/accounts:delete?key=firebase_api_key_xxx'),
              idToken: user.id_token).and_return(OpenStruct.new(body: {}.to_json, code: '200'))
      user.destroy

      expect(described_class.find_by(id: user.id)).to be_falsey
      expect(Net::HTTP).to have_received(:post_form).once
    end

    context 'with Firebaseの削除APIが失敗する' do
      it do
        allow(Net::HTTP).to receive(:post_form)
          .with(URI.parse('https://identitytoolkit.googleapis.com/v1/accounts:delete?key=firebase_api_key_xxx'),
                idToken: user.id_token).and_return(OpenStruct.new(body: { error: { message: 'エラー' } }.to_json,
                                                                  code: '400'))
        expect { user.destroy }.to raise_error('エラー')
        expect(described_class.find_by(id: user.id)).to be_truthy
        expect(Net::HTTP).to have_received(:post_form).once
      end
    end
  end
end
