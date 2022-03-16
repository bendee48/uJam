# frozen_string_literal: true

module SpotifyApi
  AUTHORIZE_URL       = 'https://accounts.spotify.com/authorize'
  TOKEN_URL           = 'https://accounts.spotify.com/api/token'
  REDIRECT_URL        = if Rails.env.development?
                          'http://localhost:3000/callback'
                        elsif Rails.env.production?
                          'https://ujam.herokuapp.com/callback'
                        end
  RECENTLY_PLAYED_URL = 'https://api.spotify.com/v1/me/player/recently-played'
  CLIENT_ID           = Rails.application.credentials.spotify.client_id.freeze
  CLIENT_SECRET       = Rails.application.credentials.spotify.client_secret.freeze

  def self.authorize(state)
    Faraday.get(AUTHORIZE_URL, { client_id: CLIENT_ID,
                                 response_type: 'code',
                                 scope: 'user-read-recently-played',
                                 redirect_uri: REDIRECT_URL,
                                 state: state })
  end

  def self.state_code
    # code to protect against csrf
    SecureRandom.base64(12)
  end

  def self.request_token(auth_code)
    # use authorization code and swap for access and refresh token
    Faraday.post(TOKEN_URL) do |req|
      req.body = { grant_type: 'authorization_code', code: auth_code, redirect_uri: REDIRECT_URL }
      req.headers['Authorization'] = "Basic #{encoded_credentials}"
    end
  end

  def self.request_refreshed_token(user)
    # when access code expires use refresh token to get new access token
    Faraday.post(TOKEN_URL) do |req|
      req.body = { grant_type: 'refresh_token', refresh_token: user.refresh_token }
      req.headers['Authorization'] = "Basic #{encoded_credentials}"
    end
  end

  def self.encoded_credentials
    Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}")
  end

  def self.get_userdata(api_url, user)
    Faraday.get(api_url) do |req|
      req.headers['Authorization'] = "Bearer #{user.access_token}"
    end
  end
end
