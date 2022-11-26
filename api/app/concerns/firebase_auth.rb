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

  def create_form_id_token!(id_token, refresh_token)
    @id_token = id_token
    User.create!(user_name: _user_name, email: _email, uid: _uid, refresh_token:, id_token:)
  end

  def find_form_id_token!(id_token)
    @id_token = id_token
    User.find_by(uid: _uid)
  rescue JWT::ExpiredSignature
    _find_and_refresh_token!
  end

  private

  def _find_and_refresh_token!
    body = _refresh_token!
    user = User.find_by!(uid: body['user_id'])
    user.update!(refresh_token: body['refresh_token'], id_token: body['id_token'])
    user
  end

  def _payload!
    return @_payload if @_payload

    @_payload, = JWT.decode(@id_token, nil, true, OPTIONS) do |header|
      cert = _fetch_certificates[header['kid']]
      OpenSSL::X509::Certificate.new(cert).public_key if cert.present?
    end

    _verify!

    @_payload
  end

  def _uid
    _payload!['sub']
  end

  def _email
    _payload!['email']
  end

  def _user_name
    _payload!['name']
  end

  def _verify!
    raise StandardError, 'Invalid auth_time' if Time.zone.at(@_payload['auth_time']).future?
    raise StandardError, 'Invalid sub' if @_payload['sub'].empty?
  end

  def _fetch_certificates
    return _certificates_cache if _certificates_cache.present?

    res = Net::HTTP.get_response(URI(CERTS_URI))
    body = JSON.parse(res.body)
    expires_at = Time.zone.parse(res.header['expires'])
    Rails.cache.write(CERTS_CACHE_KEY, body, expires_in: expires_at - Time.current)
    body
  end

  def _certificates_cache
    @_certificates_cache ||= Rails.cache.read(CERTS_CACHE_KEY)
  end

  def _refresh_token!
    responce = Net::HTTP.post_form(
      URI.parse("https://securetoken.googleapis.com/v1/token?key=#{ENV.fetch('FIREBASE_APY_KEY')}"),
      grant_type: 'refresh_token', refresh_token: User.find_by!(id_token: @id_token).refresh_token
    )
    body = JSON.parse(responce.body)
    @id_token = body['id_token']
    raise StandardError, body['error']['message'] unless responce.code == '200'

    body
  end
end
