# frozen_string_literal: true

module FirebaseAuth
  CERTS_URI = 'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'
  CERTS_CACHE_KEY = 'firebase_auth_certificates'
  OPTIONS = {
    algorithm: 'RS256',
    iss: "https://securetoken.google.com/#{ENV.fetch('FIREBASE_PROJECT_ID', nil)}",
    verify_iss: true,
    aud: ENV.fetch('FIREBASE_PROJECT_ID', nil),
    verify_aud: true,
    verify_iat: true
  }.freeze

  private

  def payload!
    return @payload if @payload

    @payload, = JWT.decode(@token, nil, true, OPTIONS) do |header|
      cert = fetch_certificates[header['kid']]
      OpenSSL::X509::Certificate.new(cert).public_key if cert.present?
    end

    verify!

    @payload
  end

  def uid
    payload!['sub']
  end

  def email
    payload!['email']
  end

  def user_name
    payload!['name']
  end

  def verify!
    raise StandardError, 'Invalid auth_time' if Time.zone.at(@payload['auth_time']).future?
    raise StandardError, 'Invalid sub' if @payload['sub'].empty?
  end

  def fetch_certificates
    return certificates_cache if certificates_cache.present?

    res = Net::HTTP.get_response(URI(CERTS_URI))
    body = JSON.parse(res.body)
    expires_at = Time.zone.parse(res.header['expires'])
    Rails.cache.write(CERTS_CACHE_KEY, body, expires_in: expires_at - Time.current)
    body
  end

  def certificates_cache
    @certificates_cache ||= Rails.cache.read(CERTS_CACHE_KEY)
  end
end
