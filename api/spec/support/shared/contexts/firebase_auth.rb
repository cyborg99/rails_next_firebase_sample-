# frozen_string_literal: true

shared_context 'with FirebaseAuth setup' do |auth_time: nil|
  let(:header) { { 'kid' => 'kid_xxxxx' } }
  let(:public_key) { { 'auth_time' => (auth_time || 1.hour.ago).to_i, 'sub' => uid, 'email' => email, 'name' => username } }
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
end

shared_context 'with FirebaseAuth 有効な公開鍵がキャッシュに保存されている' do |auth_time: nil|
  include_context 'with FirebaseAuth setup', auth_time: auth_time

  before do
    allow(JWT).to receive(:decode).with(id_token, nil, true, FirebaseAuth::OPTIONS).and_yield(header).once
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
    Rails.cache.write('firebase_auth_certificates', { 'kid_xxxxx' => 'cert_xxxxx' }, expires_in: 1.day.from_now)
    allow(OpenSSL::X509::Certificate).to receive(:new).with('cert_xxxxx').and_return(OpenStruct.new(public_key:)).once
  end
end

shared_context 'with FirebaseAuth 有効な公開鍵がキャッシュに保存されていない' do
  include_context 'with FirebaseAuth setup'

  before do
    travel_to('2022-11-01'.in_time_zone)
    allow(JWT).to receive(:decode).with(id_token, nil, true, FirebaseAuth::OPTIONS).and_yield(header).once
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
    allow(Net::HTTP).to receive(:get_response)
      .with(URI(FirebaseAuth::CERTS_URI))
      .and_return(OpenStruct.new(
                    body: { 'kid_xxxxx' => 'cert_xxxxx' }.to_json, header: { 'expires' => 1.hour.from_now.to_s }
                  )).once
    allow(OpenSSL::X509::Certificate).to receive(:new).with('cert_xxxxx').and_return(OpenStruct.new(public_key:)).once
    allow(Rails.cache).to receive(:write).with(
      FirebaseAuth::CERTS_CACHE_KEY,
      { 'kid_xxxxx' => 'cert_xxxxx' },
      expires_in: 3600
    ).once
  end
end
